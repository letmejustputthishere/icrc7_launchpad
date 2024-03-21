<script lang="ts">
	import Authentication from '$lib/components/Authentication.svelte';
	import LaunchCollectionStepper from '$lib/components/LaunchCollectionStepper.svelte';
	import '../app.pcss';
	import { AppShell, Modal, type ModalComponent } from '@skeletonlabs/skeleton';
	import Menu from '$lib/components/Menu.svelte';
	import { initializeStores } from '@skeletonlabs/skeleton';

	const modalRegistry: Record<string, ModalComponent> = {
		// Set a unique modal ID, then pass the component reference
		stepper: { ref: LaunchCollectionStepper }
	};

	initializeStores();
</script>

<Modal components={modalRegistry} />

<AppShell>
	<svelte:fragment slot="header">
		<div class="flex items-center justify-between">
			<div class="flex-1"></div>
			<!-- Invisible spacer to balance the space -->
			<div class="flex flex-1 justify-center">
				<!-- Wrapper for Menu with centering -->
				<Menu />
			</div>
			<div class="flex flex-1 justify-end">
				<!-- Wrapper for Authentication with right alignment -->
				<Authentication />
			</div>
		</div>
	</svelte:fragment>
	<slot />
</AppShell>
