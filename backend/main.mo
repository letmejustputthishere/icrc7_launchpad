import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import { deployCanister; mintCycles } "factory";
import { principalToSubaccount } "mo:account-identifier";
import IcrcNft "services/icrcNft";
import IcpLedger "canister:icp_ledger";
import Types "types";
import Vector "mo:vector";
import Trie "mo:base/Trie";
import { get; put; addCollection } "utils";

actor Main {

	stable var icrc7Wasm : ?Blob = null;
	stable var assetsWasm : ?Blob = null;

	stable let collections = Vector.new<Types.Collection>();
	stable var userCollections = Trie.empty<Principal, Vector.Vector<Nat>>();

	public shared ({ caller }) func uploadWasm(wasm : { #icrc7 : Blob; #assets : Blob }) {
		assert (Principal.isController(caller));
		switch (wasm) {
			case (#icrc7(binary)) {
				icrc7Wasm := ?binary;
			};
			case (#assets(binary)) {
				assetsWasm := ?binary;
			};
		};
	};

	public shared query func getWasm(wasm : { #icrc7; #assets }) : async ?Blob {
		switch (wasm) {
			case (#icrc7) {
				return icrc7Wasm;
			};
			case (#assets) {
				return assetsWasm;
			};
		};
	};

	public shared ({ caller }) func getUserAccount() : async IcpLedger.Account {
		{
			owner = Principal.fromActor(Main);
			subaccount = ?Blob.toArray(principalToSubaccount(caller));
		};
	};

	public shared ({ caller }) func createCollection(initArgs : IcrcNft.InitArgs) : async Result.Result<Text, Text> {
		let ?icrc7 = icrc7Wasm else {
			return #err("Wasm not uploaded");
		};
		let ?assets = assetsWasm else {
			return #err("Wasm not uploaded");
		};

		// check ICP balance of the callers dedicated account
		let balance = await IcpLedger.icrc1_balance_of({
			owner = Principal.fromActor(Main);
			subaccount = ?Blob.toArray(principalToSubaccount(caller));
		});

		if (balance < 200_000_000) {
			return #err("Not enough funds available in the Account. Make sure you send at least 2 ICP.");
		};

		// mint cycles from the ICP sent to top up the canisters
		let cyclesMinted = switch (await mintCycles(balance, caller, Principal.fromActor(Main))) {
			case (#ok(cycles)) {
				cycles;
			};
			case (#err(err)) {
				return #err(err);
			};
		};

		let icrc7Canister = await deployCanister(icrc7, to_candid (initArgs), cyclesMinted / 2);
		let assetsCanister = await deployCanister(assets, to_candid (null), cyclesMinted / 2);

		//  store collection in collections and userCollections
		userCollections := addCollection({
			caller;
			collections;
			icrc7Canister;
			assetsCanister;
			userCollections;
		});

		return #ok("Collection created");
	};

	public func getCollections() : async [Types.Collection] {
		Vector.toArray(collections);
	};

	public func getUserCollections() : async [(Principal, [Nat])] {
		Trie.toArray<Principal, Vector.Vector<Nat>, (Principal, [Nat])>(
			userCollections,
			func(k : Principal, v : Vector.Vector<Nat>) { return (k, Vector.toArray(v)) }
		);
	};

};
