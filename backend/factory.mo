import Ic "ic:aaaaa-aa";
import Icp "canister:icp_ledger";
import Cmc "canister:cmc";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Principal "mo:base/Principal";
import Types "types";

module Factory {

	public func installCode(args : Types.install_code_args) : async () {
		let canisterId = await Ic.install_code(args);
	};

	public func createCanisterWithIcp(args : Cmc.NotifyCreateCanisterArg) : async Cmc.NotifyCreateCanisterResult {
		let canisterId = await Cmc.notify_create_canister(args);
	};

	public func createCanisterWithCycles(args : Types.create_canister_args) : async Types.create_canister_result {
		Cycles.add(2_000_000_000_000); // add 2T cycles
		let result = await Ic.create_canister(args);
	};

	public func topUpCanister(args : Cmc.NotifyTopUpArg) : async Cmc.NotifyTopUpResult {
		let result = await Cmc.notify_top_up(args);
	};

	public func deployCanister(wasm_module : Blob, init_args : Blob) : async Principal {
		let { canister_id } = await createCanisterWithCycles({
			settings = null;
			sender_canister_version = null;
		});
		Debug.print(debug_show (canister_id));

		await installCode({
			arg = init_args; 
			canister_id;
			mode = #install;
			wasm_module;
			sender_canister_version = null;
		});

		return canister_id;
	};
};
