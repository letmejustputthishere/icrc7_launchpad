import Principal "mo:base/Principal";
import Result "mo:base/Result";
import { deployCanister } "factory";
import IcrcNft "services/icrcNft";

actor class Main() {

	stable var icrc7Wasm : ?Blob = null;
	stable var assetsWasm : ?Blob = null;

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

	public shared func createCollection(initArgs : IcrcNft.InitArgs) : async Result.Result<Text, Text> {
		let ?icrc7 = icrc7Wasm else {
			return #err("Wasm not uploaded");
		};
		let ?assets = assetsWasm else {
			return #err("Wasm not uploaded");
		};

		let icrc7Canister = await deployCanister(icrc7, to_candid (initArgs));
		let assetsCanister = await deployCanister(assets, to_candid (null));

		return #ok("Collection created");
	};

};
