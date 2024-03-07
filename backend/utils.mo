import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Vector "mo:vector";
import Types "types";

module {

	func key(p : Principal) : Trie.Key<Principal> {
		{
			hash = Principal.hash p;
			key = p;
		};
	};

	public func put(trie : Trie.Trie<Principal, Vector.Vector<Nat>>, k : Principal, v : Vector.Vector<Nat>) : Trie.Trie<Principal, Vector.Vector<Nat>> {
		Trie.put(trie, key k, Principal.equal, v).0;
	};

	public func get(trie : Trie.Trie<Principal, Vector.Vector<Nat>>, k : Principal) : ?Vector.Vector<Nat> {
		Trie.get(trie, key k, Principal.equal);
	};

	public func addCollection(
		arg : {
			caller : Principal;
			collections : Vector.Vector<Types.Collection>;
			icrc7Canister : Principal;
			assetsCanister : Principal;
			userCollections : Trie.Trie<Principal, Vector.Vector<Nat>>;
		}
	) : Trie.Trie<Principal, Vector.Vector<Nat>> {
		Vector.add(
			arg.collections,
			{
				owner = arg.caller;
				icrc7Canister = arg.icrc7Canister;
				assetsCanister = arg.assetsCanister;
			}
		);

		let userCollection = switch (get(arg.userCollections, arg.caller)) {
			case (null) {
				Vector.new<Nat>();
			};
			case (?userCollection) {
				userCollection;
			};
		};

		Vector.add(userCollection, Vector.size(arg.collections) - 1);

		put(arg.userCollections, arg.caller, userCollection);
	};
};
