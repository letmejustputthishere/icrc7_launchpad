import { writable } from 'svelte/store';
import { HttpAgent } from '@dfinity/agent';
import { backend, canisterId, createActor } from '../declarations/backend';
import { AuthClient } from '@dfinity/auth-client';

type State = {
	context: 'loading' | 'authenticated' | 'unauthenticated';
	actor: typeof backend;
};

const defaultState: State = {
	context: 'loading',
	actor: backend
};

export function createStore() {
	const { subscribe, update } = writable<State>(defaultState);

	async function init() {
		try {
			// create an auth client
			const authClient = await AuthClient.create();

			// check if we're authenticated already
			const context = (await authClient.isAuthenticated()) ? 'authenticated' : 'unauthenticated';

			if (context === 'authenticated') {
				const identity = authClient.getIdentity();
				const agent = new HttpAgent({ identity });

				//  create an actor with the agent
				const actor = createActor(canisterId, {
					agent
				});

				// update the store
				update(() => ({
					context,
					actor
				}));
			} else {
				// update the store
				update(() => ({
					context,
					actor: backend
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
			update((prevState) => ({
				...prevState,
				context: 'unauthenticated',
				actor: backend
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

			// At this point we're authenticated, and we can get the identity from the auth client:
			const identity = authClient.getIdentity();
			// Using the identity obtained from the auth client, we can create an agent to interact with the IC.
			const agent = new HttpAgent({ identity });
			// Using the interface description of our webapp, we create an actor that we use to call the service methods.
			const actor = createActor(canisterId, {
				agent
			});

			// update the store
			update((prevState) => ({
				...prevState,
				context: 'authenticated',
				actor
			}));
		} catch (err: unknown) {
			console.error(err);
		}
	}

	return {
		subscribe,
		update,
		init,
		logout,
		login
	};
}

export const store = await createStore();
