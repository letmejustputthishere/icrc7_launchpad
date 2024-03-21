<script lang="ts">
	import CollectionContainer from '$lib/components/CollectionContainer.svelte';
	import { store } from '$lib/store';
	import { getModalStore } from '@skeletonlabs/skeleton';

	const modalStore = getModalStore();
</script>

<svelte:head>
	<title>Launchpad</title>
</svelte:head>

<main class="container mx-auto h-full py-12">
	{#if $store.context === 'authenticated'}
		<button
			on:click={() =>
				modalStore.trigger({
					type: 'component',
					component: 'stepper'
				})}
			class="variant-glass-secondary btn my-12"
		>
			Create Collection
		</button>
	{/if}
	{#if $store.view === 'collections'}
		<CollectionContainer retrieveData={$store.backend.getRecentCollections} />
	{:else}
		<CollectionContainer retrieveData={$store.backend.getUserCollections} />
	{/if}
</main>
