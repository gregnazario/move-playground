/// Note this package is immutable
///
/// Please look at the code below and verify that it is what you expected.
module coin_lib_addr::coin_coalesce_v1 {

    use std::option;
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::primary_fungible_store;

    /// Coin matched FA not found, no reason to coalesce
    const E_COIN_FA_NOT_FOUND: u64 = 1;
    /// No FA store found for account, no reason to coalesec
    const E_PRIMARY_FA_STORE_NOT_FOUND: u64 = 2;

    /// This works around if the account has coins and fungible assets
    ///
    /// Note: It does not check if you have FA or not, it just coalesces the coins
    public entry fun coalesce_mixed_fa_coin<CoinType>(caller: &signer) {
        let metadata_opt = coin::paired_metadata<CoinType>();
        assert!(option::is_some(&metadata_opt), E_COIN_FA_NOT_FOUND);
        let caller_address = signer::address_of(caller);

        let metadata = option::destroy_some(metadata_opt);
        assert!(
            primary_fungible_store::primary_store_exists(caller_address, metadata),
            E_PRIMARY_FA_STORE_NOT_FOUND
        );

        // This should coalesce both types together, by sending back to itself
        let balance = coin::balance<CoinType>(caller_address);
        coin::transfer<CoinType>(caller, caller_address, balance);
    }
}