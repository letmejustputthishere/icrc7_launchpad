import { config } from 'dotenv';
import { HttpAgent, Identity } from '@dfinity/agent';
import { Ed25519KeyIdentity } from '@dfinity/identity';
import { Secp256k1KeyIdentity } from '@dfinity/identity-secp256k1';
import { createActor } from './src/declarations/backend';
import { ExecSyncOptions, execSync } from 'child_process';

import fs from 'fs';
import pemfile from 'pem-file';

config();

function decodeFile(file: string) {
	const rawKey = fs.readFileSync(file).toString();
	return decode(rawKey);
}

function decodeCurrentIdentity() {
	const execOptions = { stdio: ['inherit', 'pipe', 'inherit'] } as ExecSyncOptions;
	const identityName = execSync('dfx identity whoami').toString().trim();
	const pemData = execSync(`dfx identity export ${identityName}`, execOptions).toString();
	return decode(pemData);
}

function decode(rawKey: string) {
	const buf: Buffer = pemfile.decode(rawKey);
	if (rawKey.includes('EC PRIVATE KEY')) {
		if (buf.length != 118) {
			throw 'expecting byte length 118 but got ' + buf.length;
		}
		return Secp256k1KeyIdentity.fromSecretKey(buf.subarray(7, 39)) as unknown as Identity;
	}
	if (buf.length != 85) {
		throw 'expecting byte length 85 but got ' + buf.length;
	}
	return Ed25519KeyIdentity.fromSecretKey(buf.subarray(16, 48));
}

const loadWasm = (path) => {
	const buffer = fs.readFileSync(`${process.cwd()}/${path}`);
	return [...new Uint8Array(buffer)];
};

export async function uploadWasm(wasmPath, wasmType: 'icrc7' | 'assets', pemPath?) {
	const BACKEND_CANISTER_ID = process.env.BACKEND_CANISTER_ID;
	const DFX_NETWORK = process.env.DFX_NETWORK;
	const host = DFX_NETWORK == 'ic' ? 'https://ic0.app' : 'http://127.0.0.1:4943';

	const agent = new HttpAgent({
		host,
		identity: pemPath ? decodeFile(pemPath) : decodeCurrentIdentity()
	});

	const backendActor = createActor(BACKEND_CANISTER_ID!, { agent });

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
