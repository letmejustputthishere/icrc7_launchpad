<script lang="ts">
	import { clipboard } from '@skeletonlabs/skeleton';
	import { SubAccount, AccountIdentifier } from '@dfinity/ledger-icp';
	import { icp_ledger } from '../../declarations/icp_ledger';
	import { Actor } from '@dfinity/agent';
	import { store } from '$lib/store';
	import { onMount } from 'svelte';

	let accountIdentifier: AccountIdentifier;
	let timerId: string | number | NodeJS.Timeout | undefined;
	export let feePaid: boolean;

	async function calculateAccountIdentifier() {
		return AccountIdentifier.fromPrincipal({
			principal: Actor.canisterIdOf($store.backend),
			// we need to match the subaccount format of the backend canister
			subAccount: SubAccount.fromPrincipal(await $store.agent.getPrincipal())
		});
	}

	async function checkPayment() {
		const { e8s } = await icp_ledger.account_balance({
			account: accountIdentifier.toUint8Array()
		});
		if (e8s >= 200_000_000) {
			feePaid = true;
			clearInterval(timerId);
		}
	}

	onMount(async () => {
		accountIdentifier = await calculateAccountIdentifier();

		// call checkPayment every 5 seconds
		timerId = setInterval(checkPayment, 5000);
		await checkPayment();
	});

	$: accountHex = accountIdentifier ? accountIdentifier.toHex() : '';
	$: shortAccountHex = accountHex ? `${accountHex.slice(0, 8)}...${accountHex.slice(-8)}` : '';
</script>

<div class="flex items-center justify-center gap-4 p-4">
	{#if accountIdentifier}
		<div class="p-2">
			{shortAccountHex}
		</div>
		<button class="variant-filled btn" use:clipboard={accountHex}>Copy</button>
	{:else}
		<div>Loading account identifier...</div>
	{/if}
</div>
