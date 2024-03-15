<script lang="ts">
	import { onMount } from 'svelte';
	import Card from './Collection.svelte';
	import { store } from '$lib/store';
	import type { Collection } from '../../declarations/backend/backend.did';

	let collections: Collection[] = [];

	onMount(async () => {
		collections = await $store.backend.getRecentCollections();
	});
</script>

<div class="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
	{#each collections as collection}
		<Card {collection} />
	{/each}
</div>
