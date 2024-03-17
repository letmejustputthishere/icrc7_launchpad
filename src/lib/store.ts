import { writable } from 'svelte/store';
import { HttpAgent, type HttpAgentOptions } from '@dfinity/agent';
import { backend, canisterId, createActor } from '../declarations/backend';
import { AuthClient } from '@dfinity/auth-client';

type State = {
	context: 'loading' | 'authenticated' | 'unauthenticated';
	backend: typeof backend;
	agent: HttpAgent;
	view: 'collections' | 'myCollections';
};

const defaultState: State = {
	context: 'loading',
	backend: backend,
	agent: createAgent(),
	view: 'collections'
};

function createAgent(options: HttpAgentOptions = {}): HttpAgent {
	const agent = new HttpAgent(options);
	fetchRootkey(agent);
	return agent;
}

function fetchRootkey(agent: HttpAgent) {
	// Fetch root key for certificate validation during development
	if (process.env.DFX_NETWORK !== 'ic') {
		agent.fetchRootKey().catch((err) => {
			console.warn('Unable to fetch root key. Check to ensure that your local replica is running');
			console.error(err);
		});
	}
}

function createAgentAndActor(authClient: AuthClient): {
	agent: HttpAgent;
	backend: typeof backend;
} {
	// At this point we're authenticated, and we can get the identity from the auth client:
	const identity = authClient.getIdentity();

	// Using the identity obtained from the auth client, we can create an agent to interact with the IC.
	const agent = createAgent({ identity });

	// Using the interface description of our webapp, we create an actor that we use to call the service methods.
	const backend = createActor(canisterId, {
		agent
	});
	return { agent, backend };
}

export function createStore() {
	const { subscribe, update, set } = writable<State>(defaultState);

	async function init() {
		try {
			// create an auth client
			const authClient = await AuthClient.create();

			// check if we're authenticated already
			const context = (await authClient.isAuthenticated()) ? 'authenticated' : 'unauthenticated';

			if (context === 'authenticated') {
				const { agent, backend } = createAgentAndActor(authClient);

				// update the store
				update((prevState) => ({
					...prevState,
					context,
					backend,
					agent
				}));
			} else {
				// update the store
				update((prevState) => ({
					...prevState,
					context
				}));
			}
		} catch (err: unknown) {
			console.error(err);
			throw err;
		}
	}

	const logout = async () => {
		try {
			// create an auth client
			const authClient = await AuthClient.create();

			// start the logout process and wait for it to finish
			await authClient.logout();

			// update the store
			update(() => ({
				agent: createAgent(),
				context: 'unauthenticated',
				backend,
				view: 'collections'
			}));
		} catch (err: unknown) {
			console.error(err);
		}
	};

	async function login() {
		try {
			// create an auth client
			const authClient = await AuthClient.create();

			// start the login process and wait for it to finish
			await new Promise<void>((resolve, reject) => {
				authClient.login({
					identityProvider:
						process.env.DFX_NETWORK === 'ic'
							? 'https://identity.ic0.app'
							: `http://rdmx6-jaaaa-aaaaa-aaadq-cai.localhost:4943`,
					onSuccess: resolve,
					onError: reject,
					windowOpenerFeatures: `toolbar=0,location=0,menubar=0,width=400,height=600,left=${window.screen.width / 2 - 200},top=${window.screen.height / 2 - 300}`
				});
			});

			const { agent, backend } = createAgentAndActor(authClient);

			// update the store
			update((prevState) => ({
				...prevState,
				agent,
				context: 'authenticated',
				backend
			}));
		} catch (err: unknown) {
			console.error(err);
		}
	}

	return {
		subscribe,
		update,
		set,
		init,
		logout,
		login
	};
}

export const store = await createStore();
