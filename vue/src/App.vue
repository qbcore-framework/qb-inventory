<template>
  <main class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30">
    <template v-if="inventory.IsVisible.value">
      <ItemGroup :inventory="inventory"
        @start-drag="onDragStart($event, inventory)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, inventory)"
        />
      <ItemGroup
        v-if="container"
        :inventory="container"
        @start-drag="onDragStart($event, container)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, container)"
        />
  </template>
  </main>
</template>

<script lang="ts" setup>
import { inject } from 'vue';
import { Inventory } from './Models/Inventory';
import { Container } from './Models/Container';
import ItemGroup from './components/ItemGroup.vue';

let fromInventory: Inventory | null = null;
let fromIndex: number | null = null;

const inventory = inject<Inventory>('inventory')!;
const container = inject<Container>('container');

function onDragStart(index: number, inventory: Inventory) {  
  fromInventory = inventory;
  fromIndex = index;
}

function onDragEnd() {
  fromInventory = null;
  fromIndex = null;
}

function onItemDropped(index: number, dropInventory: Inventory) {
  if (fromInventory === null || fromIndex === null) return;

  fromInventory.MoveItem(fromIndex, index, dropInventory);
}
</script>

