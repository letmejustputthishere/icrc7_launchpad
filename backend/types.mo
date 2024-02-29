module {
	public type wasm_module = Blob;

	public type canister_id = Principal;

	public type install_code_args = {
		arg : Blob;
		wasm_module : wasm_module;
		mode : { #reinstall; #upgrade; #install };
		canister_id : canister_id;
		sender_canister_version : ?Nat64;
	};

	public type create_canister_args = {
		settings : ?canister_settings;
		sender_canister_version : ?Nat64;
	};

	public type create_canister_result = { canister_id : canister_id };

	public type canister_settings = {
		freezing_threshold : ?Nat;
		controllers : ?[Principal];
		reserved_cycles_limit : ?Nat;
		memory_allocation : ?Nat;
		compute_allocation : ?Nat;
	};
};
