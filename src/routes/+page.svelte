<script lang="ts">
	import CollectionContainer from '$lib/components/CollectionContainer.svelte';
	import { store } from '$lib/store';
</script>

<svelte:head>
	<title>Launchpad</title>
</svelte:head>

<main class="container mx-auto h-full py-12">
	<h1 class="text-4xl font-bold">Launchpad</h1>
	<p class="text-lg">Welcome to the Internet Computer!</p>
	{#if $store.view === 'collections'}
		<CollectionContainer retrieveData={$store.backend.getRecentCollections} />
	{:else}
		<CollectionContainer retrieveData={$store.backend.getUserCollections} />
	{/if}
</main>
