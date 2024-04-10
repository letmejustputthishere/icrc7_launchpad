import fs from 'fs';
import { createActor } from './create-actor.mts';
import { _SERVICE, idlFactory } from '../src/declarations/backend/backend.did.js';

const loadWasm = (path) => {
	const buffer = fs.readFileSync(`${process.cwd()}/${path}`);
	return [...new Uint8Array(buffer)];
};

export async function uploadWasm(wasmPath, wasmType: 'icrc7' | 'assets', pemPath?) {
	const backendActor = createActor<_SERVICE>(idlFactory, process.env.CANISTER_ID_BACKEND, pemPath);

	const wasm = loadWasm(wasmPath);

	await backendActor.uploadWasm({ [wasmType]: wasm } as
		| {
				icrc7: Uint8Array | number[];
		  }
		| {
				assets: Uint8Array | number[];
		  });
}

uploadWasm('canisters/icrc_nft.wasm', 'icrc7');
uploadWasm('canisters/assetstorage.wasm.gz', 'assets');
