module {

	public type Collection = {
		assetsCanister : Principal;
		icrc7Canister : Principal;
	};

	public type CreateCollectionArgs = {
		supply_cap : ?Nat;
		logo : ?Text;
		name : ?Text;
		description : ?Text;
		symbol : ?Text;
	};

};
