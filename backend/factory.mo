import Ic "ic:aaaaa-aa";
import Icp "canister:icp_ledger";
import Cmc "canister:cmc";
import Cycles "mo:base/ExperimentalCycles";
import IcpLedger "canister:icp_ledger";
import Principal "mo:base/Principal";
import { principalToSubaccount; accountIdentifier } "mo:account-identifier";
import Result "mo:base/Result";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Debug "mo:base/Debug";
import Error "mo:base/Error";
import Types "types";

module Factory {

	public func installCode(args : Types.install_code_args) : async () {
		let canisterId = await Ic.install_code(args);
	};

	public func updateControllers(controllers : [Principal], canisterId : Principal) : async () {
		await Ic.update_settings({
			canister_id = canisterId;
			settings = {
				controllers = ?controllers;
				compute_allocation = null;
				freezing_threshold = null;
				memory_allocation = null;
			};
			sender_canister_version = null;
		});
	};

	public func createCanisterWithIcp(args : Cmc.NotifyCreateCanisterArg) : async Cmc.NotifyCreateCanisterResult {
		let canisterId = await Cmc.notify_create_canister(args);
	};

	public func createCanisterWithCycles(args : Cmc.CreateCanisterArg, cycles : Nat) : async Cmc.CreateCanisterResult {
		Cycles.add(cycles);
		let result = await Cmc.create_canister(args);
	};

	public func topUpCanister(args : Cmc.NotifyTopUpArg) : async Cmc.NotifyTopUpResult {
		let result = await Cmc.notify_top_up(args);
	};

	public func deployCanister(wasm_module : Blob, init_args : Blob, cycles : Nat) : async Principal {
		let createCanisterResult = await createCanisterWithCycles(
			{
				settings = null;
				subnet_selection = null;
				subnet_type = null;
			},
			cycles
		);

		let canister_id = switch (createCanisterResult) {
			case (#Err(err)) {
				Debug.trap("Couldn't create canister: " # debug_show(err));
			};
			case (#Ok(canister_id)) {
				canister_id;
			};
		};

		await installCode({
			arg = init_args;
			canister_id;
			mode = #install;
			wasm_module;
			sender_canister_version = null;
		});

		return canister_id;
	};

	public func mintCycles(balance : Nat, caller : Principal, canister : Principal) : async Result.Result<Nat, Text> {
		try {
			// move the funds to the CMC
			let transferResult = await IcpLedger.transfer({
				amount = { e8s = Nat64.fromNat(balance) - 10_000 : Nat64 };
				// we move the funds from the caller dedicated subacccount
				from_subaccount = ?Blob.toArray(principalToSubaccount(caller));
				created_at_time = null;
				fee = { e8s = 10_000 : Nat64 };
				// the memo is important for the CMC to confirm the operation
				// https://github.com/dfinity/ic/blob/5fe907da2193c6051634b29133280f53f2490d52/rs/nns/cmc/src/lib.rs#L214
				// in our case the memo is TPUP in hex
				memo = 0x50555054;
				// we move the funds to the canister dedicated subaccount for the CMC
				// the CMC only checks the caller dedicated subaccount when topping up
				to = Blob.toArray(accountIdentifier(Principal.fromActor(Cmc), principalToSubaccount(canister)));
			});

			let blockIndex = switch (transferResult) {
				case (#Err(transferError)) {
					return #err("Couldn't transfer funds to CMC:\n" # debug_show (transferError));
				};
				case (#Ok(blockIndex)) { blockIndex };
			};

			// we have to pass the block index for the transfer to the CMC
			// and the canister id we want to top up
			switch (await Cmc.notify_top_up({ block_index = blockIndex; canister_id = canister })) {
				case (#Err(notifyError)) {
					return #err("Top-up failed:\n" # debug_show (notifyError));
				};
				case (#Ok(cycles)) { return #ok(cycles) };
			};

		} catch (error : Error) {
			return #err("Reject message: " # Error.message(error));
		};
	};
};
