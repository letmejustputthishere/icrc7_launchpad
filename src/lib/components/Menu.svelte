<script lang="ts">
	import { store } from '$lib/store';

	function setView(view: 'myCollections' | 'collections') {
		if (view !== $store.view) {
			$store.view = view;
		}
	}
</script>

<div class="inline-flex rounded-2xl pt-1 shadow-sm" role="group">
	<button
		on:click={() => setView('collections')}
		class:activated={$store.view === 'collections'}
		class="rounded-s-2xl border border-gray-200 bg-white px-4 py-2 hover:bg-gray-100 hover:text-blue-700"
	>
		Collections
	</button>
	<button
		disabled={!($store.context === 'authenticated')}
		on:click={() => setView('myCollections')}
		class:activated={$store.view === 'myCollections'}
		class="rounded-e-2xl border border-gray-200 bg-white px-4 py-2 focus:z-10 enabled:hover:bg-gray-100 enabled:hover:text-blue-700 disabled:cursor-not-allowed disabled:opacity-50"
	>
		My Collections
	</button>
</div>

<style>
	.activated {
		@apply z-10 text-blue-700 ring-2 ring-blue-700;
	}
</style>
