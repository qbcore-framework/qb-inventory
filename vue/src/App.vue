<template>
  <main class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30">
    <!-- <pre v-text="inventory?.Items.value" /> -->
    <ItemGroup :items="inventory.Items.value" @swap="onSwap" />

    <ItemGroup v-if="container" :items="container.Items.value"/>
  </main>
</template>

<script lang="ts" setup>
import { inject } from 'vue';
import { Inventory } from './Models/Inventory';
import ItemGroup from './components/ItemGroup.vue';
import { Container } from './Models/Container';

const inventory = inject<Inventory>('inventory')!;
const container = inject<Container>('container');

function onSwap(index: number, otherIndex: number) {
  inventory.SwapSlots(index, otherIndex);
}
</script>

