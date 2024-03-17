import { createActor } from './create-actor.mjs';
import {
	_SERVICE as _BACKEND_SERVICE,
	idlFactory as backendIdlFactory
} from '../src/declarations/backend/backend.did.js';
import {
	_SERVICE as _ICP_LEDGER_SERVICE,
	idlFactory as icpLedgerIdlFactory
} from '../src/declarations/icp_ledger/icp_ledger.did.js';
import { SubAccount, AccountIdentifier } from '@dfinity/ledger-icp';
import { Actor } from '@dfinity/agent';

export async function createCollection(pemPath?) {
	const icpLedgerActor = createActor<_ICP_LEDGER_SERVICE>(
		icpLedgerIdlFactory,
		process.env.ICP_LEDGER_CANISTER_ID,
		pemPath
	);
	const backendActor = createActor<_BACKEND_SERVICE>(
		backendIdlFactory,
		process.env.BACKEND_CANISTER_ID,
		pemPath
	);

	// transfer 2 ICP to the backend canister
	// to pay for the creation of the collection
	await icpLedgerActor.transfer({
		to: AccountIdentifier.fromPrincipal({
			principal: Actor.canisterIdOf(backendActor),
			// we need to match the subaccount format of the backend canister
			subAccount: SubAccount.fromPrincipal(await Actor.agentOf(backendActor)!.getPrincipal())
		}).toUint8Array(),
		amount: { e8s: 200_000_000n },
		// because the default dfx account we're using is the minter account,
		// we have to set the fee to 0 here.
		// for a normal ICP transfer, the fee would be 10_000 e8s
		fee: { e8s: 0n },
		from_subaccount: [],
		created_at_time: [],
		memo: 0n
	});

	// create the collection
	await backendActor.createCollection({
		description: ['this is a great collection'],
		logo: [],
		supply_cap: [1000n],
		name: ['next big thing'],
		symbol: ['nbt']
	});
}

for (let i = 0; i < 12; i++) {
	await createCollection();
}
