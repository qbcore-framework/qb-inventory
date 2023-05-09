<template>
  <main class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30">
    <template v-if="inventory.IsVisible.value">
      <ItemGroup :items="inventoryItems" @swap="onSwap" />
      <ItemGroup v-if="container" :items="containerItems ?? []"/>
  </template>
  </main>
</template>

<script lang="ts" setup>
import { inject, ref, watch } from 'vue';
import { Inventory } from './Models/Inventory';
import { Container } from './Models/Container';
import ItemGroup from './components/ItemGroup.vue';

const inventory = inject<Inventory>('inventory')!;
const container = inject<Container>('container');

let inventoryItems = inventory.Items.value
let containerItems = container?.Items.value

watch(inventory.Items, value => inventoryItems = value);
watch(container?.Items ?? ref([]), value => containerItems = value);

function onSwap(index: number, otherIndex: number) { 
  inventory.SwapSlots(index, otherIndex);
}
</script>

