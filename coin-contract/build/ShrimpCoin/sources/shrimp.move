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

    struct ShrimpCoin {}

    //#[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct ShrimpController has key {
        extend_ref: ExtendRef,
        burn: BurnCapability<ShrimpCoin>,
        freeze: FreezeCapability<ShrimpCoin>
    }

    //#[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct ShrimpMetrics has key {
        total_supply: u64,
        total_burnt: u64,
    }

    #[event]
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

        move_to(&object_signer, shrimp_controller);
    }

    entry fun add_metrics(caller: &signer) acquires ShrimpController {
        // Only publisher can call this function
        assert!(@shrimp_address == signer::address_of(caller), E_NOT_CREATOR);

        let object_address = object_address();
        let controller = borrow_global<ShrimpController>(object_address);
        let object_signer = object::generate_signer_for_extending(&controller.extend_ref);

        move_to(&object_signer, ShrimpMetrics {
            total_supply: SUPPLY,
            total_burnt: 0,
        })
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
    entry fun airdrop(caller: &signer, destination: address, amount: u64) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let shrimp_signer = object::generate_signer_for_extending(&controller.extend_ref);

        aptos_account::transfer_coins<ShrimpCoin>(&shrimp_signer, destination, amount);
    }


    /// Airdrop shrimp to an account from the supply
    entry fun airdrop_many(caller: &signer, accounts: vector<address>, amount: u64) acquires ShrimpController {
        let object_address = object_address();
        check_permission(caller, object_address);

        let controller = borrow_global<ShrimpController>(object_address);
        let shrimp_signer = object::generate_signer_for_extending(&controller.extend_ref);

        vector::for_each(accounts, |account| {
            aptos_account::transfer_coins<ShrimpCoin>(&shrimp_signer, account, amount);
        });
    }

    #[view]
    public(friend) fun treasury_supply_left(): u64 {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        coin::balance<ShrimpCoin>(object_address())
    }

    #[view]
    public(friend) fun total_supply(): u64 acquires ShrimpMetrics {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        let metrics = borrow_global<ShrimpMetrics>(object_address);
        metrics.total_supply
    }

    #[view]
    public(friend) fun total_burned(): u64 acquires ShrimpMetrics {
        let object_address = object_address();
        assert!(object::is_object(object_address), E_NOT_INITIALIZED);
        coin::balance<ShrimpCoin>(object_address());
        let metrics = borrow_global<ShrimpMetrics>(object_address);
        metrics.total_burnt
    }

    inline fun check_permission(caller: &signer, object_address: address) {
        let caller_address = signer::address_of(caller);
        let object = object::address_to_object<ShrimpController>(object_address);
        assert!(object::is_owner(object, caller_address), E_NOT_ADMIN)
    }

    #[view]
    public(friend) fun object_address(): address {
        object::create_object_address(&@shrimp_address, SHRIMP_COIN)
    }


    #[view]
    public(friend) fun account_balance(account: address): u64 {
        coin::balance<ShrimpCoin>(account)
    }
}