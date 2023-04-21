<template>
  <main class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30">
    <!-- <pre v-text="inventory?.Items.value" /> -->
    <ItemGroup :items="inventory.Items.value" />
  </main>
</template>

<script lang="ts" setup>
import { inject } from 'vue';
import { Inventory } from './Models/Inventory';
import ItemGroup from './components/ItemGroup.vue';

const inventory = inject<Inventory>('inventory')!;
</script>

