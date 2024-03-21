<script lang="ts">
	import { FileDropzone, ProgressBar } from '@skeletonlabs/skeleton';
	import { AssetManager } from '@dfinity/assets';
	import { store } from '$lib/store';
	import type { Principal } from '@dfinity/principal';
	import { getModalStore } from '@skeletonlabs/skeleton';

	const modalStore = getModalStore();

	let files: FileList;
	let uploadInProgress = false;
	export let assetCanisterId: Principal;
	let current: number;
	let total: number;

	async function onChangeHandler(e: Event) {
		uploadInProgress = true;
		const assetManager = new AssetManager({
			canisterId: assetCanisterId, // Principal of assets canister
			agent: $store.agent // Identity in agent must be authorized by the assets canister to make any changes
		});

		// Upload files
		const batch = assetManager.batch();

		// Iterate over the files and add them to the batch
		Array.from(files).forEach(async (file) => {
			await batch.store(file);
		});

		// Commit the batch
		await batch.commit({
			onProgress: (progress) => {
				current = progress.current;
				total = progress.total;
			}
		});
		modalStore.close();
	}
</script>

{#if uploadInProgress}
	<span class="m-2 text-2xl">Upload in progress...</span>
	<ProgressBar label="Progress Bar" value={current} max={total} />
{:else}
	<FileDropzone
		webkitdirectory
		directory
		multiple
		disabled={uploadInProgress}
		name="files"
		bind:files
		on:change={onChangeHandler}
	>
		<svelte:fragment slot="message">Upload a folder or drag and drop</svelte:fragment>
	</FileDropzone>
{/if}
