module shrimp_address::shrimp {

    use std::signer;
    use std::string::utf8;
    use std::vector;
    use aptos_framework::aptos_account;
    use aptos_framework::coin;
    use aptos_framework::coin::{BurnCapability, FreezeCapability};
    use aptos_framework::event::emit;
    use aptos_framework::object;
    use aptos_framework::object::{ExtendRef};

    const SHRIMP_COIN: vector<u8> = b"ShrimpCoin";
    const SYM: vector<u8> = b"SHRIMP";
    const SUPPLY: u64 = 121212121;
    const DECIMALS: u8 = 0;

    /// Not creator, nice try you can't do anything to Shrimp coin
    const E_NOT_CREATOR: u64 = 1;
    /// Not admin, nice try you can't do anything to Shrimp coin
    const E_NOT_ADMIN: u64 = 2;
    /// Can't create SHRIMP twice
    const E_ALREADY_INITIALIZED: u64 = 3;
    /// Shrimp not initialized
    const E_NOT_INITIALIZED: u64 = 4;
    /// Number of addresses doesn't match amounts
    const E_ADDRESS_COUNT_NOT_MATCH_AMOUNT_COUNT: u64 = 5;

    struct ShrimpCoin {}

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// Controls the Shrimp token
    struct ShrimpController has key {
        /// Extend ref is to make updates if pieces are missing
        extend_ref: ExtendRef,
        /// Burn capability to burn tokens forever
        burn: BurnCapability<ShrimpCoin>,
        /// Freeze capability freezes someone from transferring tokens
        freeze: FreezeCapability<ShrimpCoin>
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    /// Note that this is not parallel.  If there were a lot of mints, or burns this would slow down performance
    /// But, since these are happening manually, it will likely not be the case.
    struct ShrimpMetrics has key {
        total_supply: u64,
        total_burnt: u64,
    }

    #[event]
    /// An event telling who and how much shrimp was burned
    struct ShrimpBurnEvent has store, drop {
        account: address,
        amount: u64,
    }

    /// Initialize shrimp, can only be called once
    entry fun initialize(caller: &signer) {
        // Only publisher can call this function
        assert!(@shrimp_address == signer::address_of(caller), E_NOT_CREATOR);

        // Only initialize once
        let object_address = object_address();
        assert!(!object::is_object(object_address), E_ALREADY_INITIALIZED);

        // Create object for coin owner
        let constructor = object::create_named_object(caller, SHRIMP_COIN);
        let extend_ref = object::generate_extend_ref(&constructor);
        let object_signer = object::generate_signer(&constructor);
        let object_address = signer::address_of(&object_signer);

        // Create the coin
        let (burn, freeze, mint) = coin::initialize<ShrimpCoin>(
            caller,
            utf8(SHRIMP_COIN),
            utf8(SYM),
            DECIMALS,
            false
        );

        // Make object an account to hold coins
        aptos_account::create_account(object_address);

        // Mint initial supply, deposit in the object
        let coins = coin::mint(SUPPLY, &mint);
        coin::register<ShrimpCoin>(&object_signer);
        coin::deposit(object_address, coins);

        // Destroy mint ability
        coin::destroy_mint_cap(mint);

        // Keep freeze and burn for fun
        let shrimp_controller = ShrimpController {
            extend_ref,
            burn,
            freeze,
        };
        move_to(&object_signer, ShrimpMetrics {
            total_supply: SUPPLY,
            total_burnt: 0,
        });

        move_to(&object_signer, shrimp_controller);
    }

    /// Burn coins in someone else's account
    entry fun burn(caller: &signer, account: address, amount: u64) acquires ShrimpController, ShrimpMetrics {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let metrics = borrow_global_mut<ShrimpMetrics>(object_address);
        burn_tokens(&controller.burn, metrics, account, amount);
    }


    /// Burn coins in someone else's account
    entry fun burn_many(
        caller: &signer,
        accounts: vector<address>,
        amount: u64
    ) acquires ShrimpController, ShrimpMetrics {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let metrics = borrow_global_mut<ShrimpMetrics>(object_address);
        vector::for_each(accounts, |account| {
            burn_tokens(&controller.burn, metrics, account, amount);
        });
    }

    /// Burns tokens and emits metrics
    inline fun burn_tokens(
        burn: &BurnCapability<ShrimpCoin>,
        metrics: &mut ShrimpMetrics,
        account: address,
        amount: u64
    ) {
        coin::burn_from(account, amount, burn);

        metrics.total_burnt = metrics.total_burnt + amount;
        metrics.total_supply = metrics.total_supply - amount;

        emit(ShrimpBurnEvent {
            account,
            amount
        });
    }

    /// Burn coins from the shrimp supply directly
    entry fun burn_from_supply(caller: &signer, amount: u64) acquires ShrimpController, ShrimpMetrics {
        burn(caller, object_address(), amount);
    }

    /// Freeze an account's shrimp store
    entry fun freeze_shrimp(caller: &signer, account: address) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        coin::freeze_coin_store(account, &controller.freeze);
    }

    /// Unfreeze an account's shrimp store
    entry fun unfreeze_shrimp(caller: &signer, account: address) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        coin::unfreeze_coin_store(account, &controller.freeze);
    }

    /// Airdrop shrimp to an account from the supply
    entry fun airdrop(caller: &signer, account: address, amount: u64) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let shrimp_signer = object::generate_signer_for_extending(&controller.extend_ref);

        airdrop_tokens(&shrimp_signer, account, amount);
    }


    /// Airdrop shrimp to multiple accounts from the supply, lists must match in length
    entry fun airdrop_many(caller: &signer, accounts: vector<address>, amounts: vector<u64>) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        // Ensure lists are same length
        let length = vector::length(&accounts);
        assert!(length == vector::length(&amounts), E_ADDRESS_COUNT_NOT_MATCH_AMOUNT_COUNT);

        let controller = borrow_global<ShrimpController>(object_address);
        let shrimp_signer = object::generate_signer_for_extending(&controller.extend_ref);

        // Airdrop to each
        for (i in 0..length) {
            airdrop_tokens(&shrimp_signer, *vector::borrow(&accounts, i), *vector::borrow(&amounts, i));
        }
    }

    /// Airdrop shrimp to accounts with the same amount each
    entry fun airdrop_many_same(caller: &signer, accounts: vector<address>, amount: u64) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let shrimp_signer = object::generate_signer_for_extending(&controller.extend_ref);

        // Airdrop to each
        vector::for_each(accounts, |account| {
            airdrop_tokens(&shrimp_signer, account, amount);
        });
    }

    /// Transfers tokens to given users from the treasury
    fun airdrop_tokens(shrimp_signer: &signer, destination: address, amount: u64) {
        aptos_account::transfer_coins<ShrimpCoin>(shrimp_signer, destination, amount);
    }

    #[view]
    /// Tells the amount of treasury funds left in the object
    public(friend) fun treasury_supply_left(): u64 {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        coin::balance<ShrimpCoin>(object_address())
    }

    #[view]
    /// Tells the total supply currently available
    public(friend) fun total_supply(): u64 acquires ShrimpMetrics {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        let metrics = borrow_global<ShrimpMetrics>(object_address);
        metrics.total_supply
    }

    #[view]
    /// Tells the total amount of the token burned
    public(friend) fun total_burned(): u64 acquires ShrimpMetrics {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        coin::balance<ShrimpCoin>(object_address());
        let metrics = borrow_global<ShrimpMetrics>(object_address);
        metrics.total_burnt
    }

    /// Checks permisison for changes to the Shrimp owners
    inline fun check_permission(caller: &signer, object_address: address) {
        let caller_address = signer::address_of(caller);
        let object = object::address_to_object<ShrimpController>(object_address);
        assert!(object::is_owner(object, caller_address), E_NOT_ADMIN)
    }

    #[view]
    /// Retrieves the address of the shrimp coin controller
    public(friend) fun object_address(): address {
        object::create_object_address(&@shrimp_address, SHRIMP_COIN)
    }


    #[view]
    /// Retrieves the shrimp balance of any account
    public(friend) fun account_balance(account: address): u64 {
        coin::balance<ShrimpCoin>(account)
    }
}