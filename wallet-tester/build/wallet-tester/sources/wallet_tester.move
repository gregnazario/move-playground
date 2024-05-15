module deploy_addr::wallet_tester {

    use aptos_framework::object::{Object, ObjectCore};
    use std::option::Option;
    use std::fixed_point32::FixedPoint32;
    use aptos_std::fixed_point64::FixedPoint64;
    use std::string::String;

    public(friend) entry fun test_bool(_input: bool) {}

    public(friend) entry fun test_address(_input: address) {}

    public(friend) entry fun test_string(_input: String) {}

    public(friend) entry fun test_u8(_input: u8) {}

    public(friend) entry fun test_u16(_input: u16) {}

    public(friend) entry fun test_u32(_input: u32) {}

    public(friend) entry fun test_u64(_input: u64) {}

    public(friend) entry fun test_u128(_input: u128) {}

    public(friend) entry fun test_u256(_input: u256) {}

    public(friend) entry fun test_f32(_input: FixedPoint32) {}

    public(friend) entry fun test_f64(_input: FixedPoint64) {}

    public(friend) entry fun test_object(_x: Object<ObjectCore>) {}

    public(friend) entry fun test_option_bool(_x: Option<bool>) {}

    public(friend) entry fun test_option_address(_x: Option<address>) {}

    public(friend) entry fun test_option_string(_x: Option<String>) {}

    public(friend) entry fun test_option_u8(_x: Option<u8>) {}

    public(friend) entry fun test_option_u16(_x: Option<u16>) {}

    public(friend) entry fun test_option_u32(_x: Option<u32>) {}

    public(friend) entry fun test_option_u64(_x: Option<u64>) {}

    public(friend) entry fun test_option_u128(_x: Option<u128>) {}

    public(friend) entry fun test_option_u256(_x: Option<u256>) {}

    public(friend) entry fun test_option_f32(_x: Option<FixedPoint32>) {}

    public(friend) entry fun test_option_f64(_x: Option<FixedPoint64>) {}

    public(friend) entry fun test_option_object(_x: Option<Object<ObjectCore>>) {}

    public(friend) entry fun test_vector_bool(_x: vector<bool>) {}

    public(friend) entry fun test_vector_address(_x: vector<address>) {}

    public(friend) entry fun test_vector_string(_x: vector<String>) {}

    public(friend) entry fun test_vector_u8(_x: vector<u8>) {}

    public(friend) entry fun test_vector_u16(_x: vector<u16>) {}

    public(friend) entry fun test_vector_u32(_x: vector<u32>) {}

    public(friend) entry fun test_vector_u64(_x: vector<u64>) {}

    public(friend) entry fun test_vector_u128(_x: vector<u128>) {}

    public(friend) entry fun test_vector_u256(_x: vector<u256>) {}

    public(friend) entry fun test_vector_f32(_x: vector<FixedPoint32>) {}

    public(friend) entry fun test_vector_f64(_x: vector<FixedPoint64>) {}

    public(friend) entry fun test_vector_object(_x: vector<Object<ObjectCore>>) {}

    public(friend) entry fun test_option_vector_bool(_x: Option<vector<bool>>) {}

    public(friend) entry fun test_option_vector_address(_x: Option<vector<address>>) {}

    public(friend) entry fun test_option_vector_string(_x: Option<vector<String>>) {}

    public(friend) entry fun test_option_vector_u8(_x: Option<vector<u8>>) {}

    public(friend) entry fun test_option_vector_u16(_x: Option<vector<u16>>) {}

    public(friend) entry fun test_option_vector_u32(_x: Option<vector<u32>>) {}

    public(friend) entry fun test_option_vector_u64(_x: Option<vector<u64>>) {}

    public(friend) entry fun test_option_vector_u128(_x: Option<vector<u128>>) {}

    public(friend) entry fun test_option_vector_u256(_x: Option<vector<u256>>) {}

    public(friend) entry fun test_option_vector_f32(_x: Option<vector<FixedPoint32>>) {}

    public(friend) entry fun test_option_vector_f64(_x: Option<vector<FixedPoint64>>) {}

    public(friend) entry fun test_option_vector_object(_x: Option<vector<Object<ObjectCore>>>) {}

    public(friend) entry fun test_vector_vector_bool(_x: vector<vector<bool>>) {}

    public(friend) entry fun test_vector_vector_address(_x: vector<vector<address>>) {}

    public(friend) entry fun test_vector_vector_string(_x: vector<vector<String>>) {}

    public(friend) entry fun test_vector_vector_u8(_x: vector<vector<u8>>) {}

    public(friend) entry fun test_vector_vector_u16(_x: vector<vector<u16>>) {}

    public(friend) entry fun test_vector_vector_u32(_x: vector<vector<u32>>) {}

    public(friend) entry fun test_vector_vector_u64(_x: vector<vector<u64>>) {}

    public(friend) entry fun test_vector_vector_u128(_x: vector<vector<u128>>) {}

    public(friend) entry fun test_vector_vector_u256(_x: vector<vector<u256>>) {}

    public(friend) entry fun test_vector_vector_f32(_x: vector<vector<FixedPoint32>>) {}

    public(friend) entry fun test_vector_vector_f64(_x: vector<vector<FixedPoint64>>) {}

    public(friend) entry fun test_vector_vector_object(_x: vector<vector<Object<ObjectCore>>>) {}

    /// Now we're getting really crazy
    public(friend) entry fun test_vector_vector_option_object(_x: vector<vector<Option<Object<ObjectCore>>>>) {}

    // -- View Functions --

    #[view]
    public(friend) fun view_bool(_input: bool): bool { return true }

    #[view]
    public(friend) fun view_address(_input: address): bool { return true }

    #[view]
    public(friend) fun view_string(_input: String): bool { return true }

    #[view]
    public(friend) fun view_u8(_input: u8): bool { return true }

    #[view]
    public(friend) fun view_u16(_input: u16): bool { return true }

    #[view]
    public(friend) fun view_u32(_input: u32): bool { return true }

    #[view]
    public(friend) fun view_u64(_input: u64): bool { return true }

    #[view]
    public(friend) fun view_u128(_input: u128): bool { return true }

    #[view]
    public(friend) fun view_u256(_input: u256): bool { return true }

    #[view]
    public(friend) fun view_f32(_input: FixedPoint32): bool { return true }

    #[view]
    public(friend) fun view_f64(_input: FixedPoint64): bool { return true }

    #[view]
    public(friend) fun view_object(_x: Object<ObjectCore>): bool { return true }

    #[view]
    public(friend) fun view_option_bool(_x: Option<bool>): bool { return true }

    #[view]
    public(friend) fun view_option_address(_x: Option<address>): bool { return true }

    #[view]
    public(friend) fun view_option_string(_x: Option<String>): bool { return true }

    #[view]
    public(friend) fun view_option_u8(_x: Option<u8>): bool { return true }

    #[view]
    public(friend) fun view_option_u16(_x: Option<u16>): bool { return true }

    #[view]
    public(friend) fun view_option_u32(_x: Option<u32>): bool { return true }

    #[view]
    public(friend) fun view_option_u64(_x: Option<u64>): bool { return true }

    #[view]
    public(friend) fun view_option_u128(_x: Option<u128>): bool { return true }

    #[view]
    public(friend) fun view_option_u256(_x: Option<u256>): bool { return true }

    #[view]
    public(friend) fun view_option_f32(_x: Option<FixedPoint32>): bool { return true }

    #[view]
    public(friend) fun view_option_f64(_x: Option<FixedPoint64>): bool { return true }

    #[view]
    public(friend) fun view_option_object(_x: Option<Object<ObjectCore>>): bool { return true }

    #[view]
    public(friend) fun view_vector_bool(_x: vector<bool>): bool { return true }

    #[view]
    public(friend) fun view_vector_address(_x: vector<address>): bool { return true }

    #[view]
    public(friend) fun view_vector_string(_x: vector<String>): bool { return true }

    #[view]
    public(friend) fun view_vector_u8(_x: vector<u8>): bool { return true }

    #[view]
    public(friend) fun view_vector_u16(_x: vector<u16>): bool { return true }

    #[view]
    public(friend) fun view_vector_u32(_x: vector<u32>): bool { return true }

    #[view]
    public(friend) fun view_vector_u64(_x: vector<u64>): bool { return true }

    #[view]
    public(friend) fun view_vector_u128(_x: vector<u128>): bool { return true }

    #[view]
    public(friend) fun view_vector_u256(_x: vector<u256>): bool { return true }

    #[view]
    public(friend) fun view_vector_f32(_x: vector<FixedPoint32>): bool { return true }

    #[view]
    public(friend) fun view_vector_f64(_x: vector<FixedPoint64>): bool { return true }

    #[view]
    public(friend) fun view_vector_object(_x: vector<Object<ObjectCore>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_bool(_x: Option<vector<bool>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_address(_x: Option<vector<address>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_string(_x: Option<vector<String>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u8(_x: Option<vector<u8>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u16(_x: Option<vector<u16>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u32(_x: Option<vector<u32>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u64(_x: Option<vector<u64>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u128(_x: Option<vector<u128>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_u256(_x: Option<vector<u256>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_f32(_x: Option<vector<FixedPoint32>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_f64(_x: Option<vector<FixedPoint64>>): bool { return true }

    #[view]
    public(friend) fun view_option_vector_object(_x: Option<vector<Object<ObjectCore>>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_bool(_x: vector<vector<bool>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_address(_x: vector<vector<address>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_string(_x: vector<vector<String>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u8(_x: vector<vector<u8>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u16(_x: vector<vector<u16>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u32(_x: vector<vector<u32>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u64(_x: vector<vector<u64>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u128(_x: vector<vector<u128>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_u256(_x: vector<vector<u256>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_f32(_x: vector<vector<FixedPoint32>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_f64(_x: vector<vector<FixedPoint64>>): bool { return true }

    #[view]
    public(friend) fun view_vector_vector_object(_x: vector<vector<Object<ObjectCore>>>): bool { return true }

    #[view]
    /// Now we're getting really crazy
    public(friend) fun view_vector_vector_option_object(
        _x: vector<vector<Option<Object<ObjectCore>>>>
    ): bool { return true }
}