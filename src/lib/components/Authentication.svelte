<script lang="ts">
	import { store } from '$lib/store';
	import { onMount } from 'svelte';

	onMount(async () => {
		await store.init();
	});

	let buttonText = '';
	let buttonAction = () => {};

	// Reactive statement to determine button text and action based on the store's state
	$: {
		switch ($store.context) {
			case 'loading':
				buttonText = 'Loading...';
				buttonAction = () => {}; // No action on click
				break;
			case 'authenticated':
				buttonText = 'Sign out';
				buttonAction = store.logout;
				break;
			default:
				buttonText = 'Sign in with Internet Identity';
				buttonAction = store.login;
		}
	}
</script>

<button class="variant-glass-secondary btn" on:click={buttonAction}>
	<span>{buttonText}</span>
</button>
