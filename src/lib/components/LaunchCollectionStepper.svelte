<script lang="ts">
	import CollectionDetailsForm from '$lib/components/CollectionDetailsForm.svelte';
	import PayFee from '$lib/components/PayFee.svelte';
	import type { Principal } from '@dfinity/principal';
	import UploadAssets from './UploadAssets.svelte';

	let step: 'pay' | 'details' | 'upload' = 'pay';
	let assetCanisterId: Principal;
</script>

<div class="card w-1/2 p-4">
	{#if step === 'pay'}
		<header class="card-header mb-2 text-2xl">Pay Collection Fee</header>
		<PayFee bind:step />
	{:else if step === 'details'}
		<header class="card-header mb-2 text-2xl">Provide Collection Details</header>
		<CollectionDetailsForm bind:step bind:assetCanisterId />
	{:else if step === 'upload'}
		<header class="card-header mb-2 text-2xl">Upload Assets</header>
		<UploadAssets bind:assetCanisterId />
	{/if}
</div>
