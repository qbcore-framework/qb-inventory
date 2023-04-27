<template>
  <main class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30">
    <template v-if="inventory.IsVisible.value">
      <ItemGroup :items="inventory.Items.value" @swap="onSwap" />
      <ItemGroup v-if="container" :items="container.Items.value"/>
  </template>
  </main>
</template>

<script lang="ts" setup>
import { inject } from 'vue';
import { Inventory } from './Models/Inventory';
import { Container } from './Models/Container';
import ItemGroup from './components/ItemGroup.vue';

const inventory = inject<Inventory>('inventory')!;
const container = inject<Container>('container');

function onSwap(index: number, otherIndex: number) {
  inventory.SwapSlots(index, otherIndex);
}
</script>

