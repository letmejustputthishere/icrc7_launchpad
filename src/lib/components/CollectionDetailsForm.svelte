<script lang="ts">
	import { createForm } from 'felte';
	import { validator } from '@felte/validator-yup';
	import * as yup from 'yup';
	import { reporter, ValidationMessage } from '@felte/reporter-svelte';
	import { toNullable } from '@dfinity/utils';
	import { store } from '$lib/store';

	export let step;
	export let assetCanisterId;
	let isLoading = false;

	const schema = yup.object({
		name: yup.string().required(),
		symbol: yup.string().required(),
		logo: yup
			.string()
			.required('Logo is required')
			.test('is-url-or-data-url', 'Logo must be a valid URL or data URL', async (value) => {
				// First, try to validate as a URL
				try {
					await yup.string().url().validate(value);
					return true; // It's a valid URL
				} catch (urlError) {
					// Not a valid URL, check if it's a valid data URL
					const dataUrlRegex = /^data:([a-zA-Z]+\/[a-zA-Z]+)?(;base64)?,[a-zA-Z0-9+/=]+$/i;
					return dataUrlRegex.test(value);
				}
			}),
		description: yup.string().required().max(500),
		supplyCap: yup.number().moreThan(0)
	});

	const { form } = createForm<yup.InferType<typeof schema>>({
		onSubmit: async (values) => {
			isLoading = true;
			const result = await createCollection(values);
			console.log(result);
			if ('ok' in result) {
				assetCanisterId = result.ok.assetsCanister;
			}
		},
		onSuccess(response, context) {
			step = 'upload';
		},
		// ideally we would handle errors here
		onError(response, context) {
			console.error(response);
		},
		extend: [validator({ schema }), reporter]
	});

	async function createCollection(collectionDetails: {
		name: string;
		symbol: string;
		logo: string;
		description: string;
		supplyCap?: number;
	}) {
		return await $store.backend.createCollection({
			description: toNullable(collectionDetails.description),
			logo: toNullable(collectionDetails.logo),
			supply_cap: toNullable(
				collectionDetails.supplyCap ? BigInt(collectionDetails.supplyCap) : null
			),
			name: toNullable(collectionDetails.name),
			symbol: toNullable(collectionDetails.symbol)
		});
	}
</script>

<form class="card variant-soft flex flex-col gap-4 p-4" use:form>
	<label class="">
		<span>Name</span>
		<input class="input" type="text" name="name" placeholder="Enter name..." />
		<ValidationMessage for="name" let:messages={message}>
			<span class="text-red-500">{message}</span>
			<span slot="placeholder">Please enter a collection name.</span>
		</ValidationMessage>
	</label>
	<label class="">
		<span>Symbol</span>
		<input class="input" type="text" name="symbol" placeholder="Enter symbol..." />
		<ValidationMessage for="symbol" let:messages={message}>
			<span class="text-red-500">{message}</span>
			<span slot="placeholder">Please specify the symbol for your collection.</span>
		</ValidationMessage>
	</label>
	<label class="">
		<span>Logo</span>
		<input class="input" type="text" name="logo" placeholder="Enter URL or data url..." />
		<ValidationMessage for="logo" let:messages={message}>
			<span class="text-red-500">{message}</span>
			<span slot="placeholder">Please enter a Logo. This can either be a URL or a data URL.</span>
		</ValidationMessage>
	</label>
	<label class="">
		<span>Supply Cap</span>
		<input class="input" type="number" name="supplyCap" placeholder="Enter supply cap..." />
		<ValidationMessage for="supplyCap" let:messages={message}>
			<span class="text-red-500">{message}</span>
			<span slot="placeholder">Specify the supply cap of the collection.</span>
		</ValidationMessage>
	</label>
	<label class="">
		<span>Description</span>
		<textarea class="textarea" name="description" rows="3" placeholder="Enter description..." />
		<ValidationMessage for="description" let:messages={message}>
			<span class="text-red-500">{message}</span>
			<span slot="placeholder">Provide a description for the collection.</span>
		</ValidationMessage>
	</label>
	<div class="flex justify-end">
		<button class="variant-filled btn" type="submit" disabled={isLoading}>
			{#if isLoading}
				<svg
					aria-hidden="true"
					class="mr-1 h-4 w-4 animate-spin fill-black"
					viewBox="0 0 100 101"
					fill="none"
					xmlns="http://www.w3.org/2000/svg"
				>
					<path
						d="M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z"
						fill="currentColor"
					/>
					<path
						d="M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z"
						fill="currentFill"
					/>
				</svg>
			{/if}
			Next</button
		>
	</div>
</form>
