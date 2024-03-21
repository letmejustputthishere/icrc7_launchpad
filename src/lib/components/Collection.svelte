<script lang="ts">
	import { onMount } from 'svelte';
	import { Actor } from '@dfinity/agent';
	import type { Collection } from '../../declarations/backend/backend.did';
	import { Avatar } from '@skeletonlabs/skeleton';
	import { idlFactory, type _SERVICE, type Value } from '../../declarations/icrcNft/icrcNft';
	import { store } from '$lib/store';
	import Identicon from 'identicon.js';

	export let collection: Collection;

	let actor;
	let metadata: { [key: string]: any };

	let isLoading = true;

	onMount(async () => {
		actor = Actor.createActor<_SERVICE>(idlFactory, {
			agent: $store.agent,
			canisterId: collection.icrc7Canister
		});

		const collectionMetadata = await actor.icrc7_collection_metadata();
		metadata = destructureMetadata(collectionMetadata);
		isLoading = false;
	});

	// Assuming metadata is of type [string, Value][]
	function destructureMetadata(metadata: [string, Value][]): { [key: string]: any } {
		const result: { [key: string]: any } = {};

		metadata.forEach(([key, value]) => {
			result[key] = parseValue(value);
		});

		return result;
	}

	function parseValue(value: Value): any {
		if ('Int' in value) {
			return value.Int;
		} else if ('Nat' in value) {
			return value.Nat;
		} else if ('Blob' in value) {
			// Convert Blob to a suitable format if necessary, or handle as needed
			return value.Blob;
		} else if ('Text' in value) {
			return value.Text;
		} else if ('Array' in value) {
			return value.Array.map(parseValue);
		} else if ('Map' in value) {
			const obj: { [key: string]: any } = {};
			value.Map.forEach(([k, v]) => {
				obj[k] = parseValue(v);
			});
			return obj;
		}
		return null; // Or throw an error if value structure is unexpected
	}
</script>

{#if isLoading}
	<div class="card card-hover h-88 space-y-4 p-4">
		<div class="card-header flex items-center justify-between gap-5">
			<div class="placeholder flex-auto animate-pulse" />
			<div class="placeholder-circle w-16 animate-pulse" />
		</div>
		<div class="placeholder animate-pulse" />
		<div class="placeholder animate-pulse" />
		<div class="placeholder animate-pulse" />
		<div class="placeholder animate-pulse" />
		<div class="placeholder animate-pulse" />
	</div>
{:else}
	<div class="card card-hover space-y-4 p-4">
		<div class="card-header flex items-center justify-between gap-5">
			<div class="flex-auto">
				<div>{metadata['icrc7:name']} {metadata['icrc7:symbol']}</div>
			</div>
			<Avatar
				src={metadata['icrc7:logo'] ??
					'data:image/png;base64,' + new Identicon(window.crypto.randomUUID(), 64)}
			></Avatar>
		</div>
		<div>Description: {metadata['icrc7:description'] ?? '/'}</div>
		<div>Supply Cap: {metadata['icrc7:supply_cap'] ?? '∞'}</div>
		<div>Total Supply: {metadata['icrc7:total_supply']}</div>
		<div>NFT Canister: {collection.icrc7Canister.toString()}</div>
		<div>Assets Canister: {collection.assetsCanister.toString()}</div>
	</div>
{/if}
