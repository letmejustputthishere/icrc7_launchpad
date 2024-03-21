<script lang="ts">
	import DestinationAddress from './DestinationAddress.svelte';

	let feePaid = false;
	export let step;
</script>

To create a collection on the launchpad you have to pay a fee of 2 ICP.<br />
It does not matter which wallet you send this fee from, it could be transferred straight from an exchange
or your NNS wallet.
<DestinationAddress bind:feePaid />
You can continue once the funds have been received.
<div class="flex items-center justify-end">
	<button class="variant-filled btn" disabled={!feePaid} on:click={() => (step = 'details')}>
		Next</button
	>
</div>
