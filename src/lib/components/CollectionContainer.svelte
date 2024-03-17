<script lang="ts">
	import { onMount } from 'svelte';
	import Card from './Collection.svelte';
	import type { Collection } from '../../declarations/backend/backend.did';
	import { ProgressRadial } from '@skeletonlabs/skeleton';

	// pass the respective method to retrieve data to the component
	export let retrieveData: () => Promise<Collection[]>;

	let collections: Collection[] = [];
	let loading: boolean = true;

	onMount(async () => {
		loading = true;
		collections = await retrieveData();
		loading = false;
	});
</script>

{#if loading}
	<div class="flex h-full items-center justify-center">
		<ProgressRadial value={undefined} />
	</div>
{:else}
	<div class="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
		{#each collections as collection}
			<Card {collection} />
		{/each}
	</div>
{/if}
