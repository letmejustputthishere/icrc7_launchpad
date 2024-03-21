import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import { deployCanister; mintCycles; updateControllers } "factory";
import { principalToSubaccount } "mo:account-identifier";
import IcrcNft "services/icrcNft";
import IcpLedger "canister:icp_ledger";
import Types "types";
import Vector "mo:vector";
import Trie "mo:base/Trie";
import { get; addCollection } "utils";

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

	public shared ({ caller }) func createCollection(initArgs : Types.CreateCollectionArgs) : async Result.Result<{ assetsCanister : Principal; icrc7Canister : Principal }, Text> {
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

		let assetsCanister = await deployCanister(assets, to_candid (null), cyclesMinted / 2);
		// create an actor from the assets canister
		let assetsActor : actor { authorize : shared (other : Principal) -> async () } = actor (Principal.toText(assetsCanister));
		// authorize the caller to upload assets
		await assetsActor.authorize(caller);

		let icrc7InitArgs : IcrcNft.InitArgs = {
			icrc7_args = ?{
				initArgs and {
					deployer = caller;
					allow_transfers = null;
					burn_account = null;
					default_take_value = null;
					permitted_drift = null;
					max_take_value = null;
					max_update_batch_size = null;
					max_query_batch_size = null;
					max_memo_size = null;
					supported_standards = null;
				}
			};
			assetCanisterId = assetsCanister;
			icrc30_args = null;
			icrc3_args = null;
		};
		let icrc7Canister = await deployCanister(icrc7, to_candid (icrc7InitArgs), cyclesMinted / 2);

		//  store collection in collections and userCollections
		userCollections := addCollection({
			caller;
			collections;
			icrc7Canister;
			assetsCanister;
			userCollections;
		});

		// remove the factory canister as a controller
		await updateControllers([caller], assetsCanister);
		await updateControllers([caller], icrc7Canister);

		return #ok({ assetsCanister; icrc7Canister });
	};

	public query func getRecentCollections() : async [Types.Collection] {
		Vector.toArray(collections)
		|> Array.take(_, -12)
		|> Array.reverse(_);
	};

	public shared query ({ caller }) func getUserCollections() : async [Types.Collection] {
		let ?collectionIndices : ?Vector.Vector<Nat> = get(userCollections, caller) else {
			return [];
		};

		Vector.map<Nat, Types.Collection>(
			collectionIndices,
			func(i : Nat) {
				return Vector.get(collections, i);
			}
		)
		|> Vector.toArray(_)
		|> Array.reverse(_);
	};

};
