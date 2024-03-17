import { config } from 'dotenv';
import { Actor, ActorSubclass, HttpAgent, Identity } from '@dfinity/agent';
import { Ed25519KeyIdentity } from '@dfinity/identity';
import { Secp256k1KeyIdentity } from '@dfinity/identity-secp256k1';
import { ExecSyncOptions, execSync } from 'child_process';

import fs from 'fs';
import pemfile from 'pem-file';
import { IDL } from '@dfinity/candid';

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

export function createAgent(pemPath?: string): HttpAgent {
	const DFX_NETWORK = process.env.DFX_NETWORK;
	const host = DFX_NETWORK == 'ic' ? 'https://ic0.app' : 'http://127.0.0.1:4943';

	const agent = new HttpAgent({
		host,
		identity: pemPath ? decodeFile(pemPath) : decodeCurrentIdentity()
	});

	// Fetch root key for certificate validation during development
	if (process.env.DFX_NETWORK !== 'ic') {
		agent.fetchRootKey().catch((err) => {
			console.warn('Unable to fetch root key. Check to ensure that your local replica is running');
			console.error(err);
		});
	}

	return agent;
}

export function createActor<_SERVICE>(
	idlFactory: IDL.InterfaceFactory,
	canisterId: string | undefined,
	pemPath?: string
): ActorSubclass<_SERVICE> {
	// create an agent
	const agent = createAgent(pemPath);

	// create an actor
	return Actor.createActor<_SERVICE>(idlFactory, {
		agent,
		canisterId: canisterId!
	});
}
