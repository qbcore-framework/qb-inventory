<template>
  <main
    class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30"
  >
    <template v-if="inventory.IsVisible.value">
      <ItemGroup
        :inventory="inventory"
        :canSelectItems="true"
        @start-drag="onDragStart($event, inventory)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, inventory)"
        @quick-move="onQuickMove($event, inventory)"
        @select-item="onSelectItem($event, inventory)"
      />
      <input
        class="h-12 w-20 text-black"
        v-model.number="moveAmount"
        min="0"
        max="100"
        @keyup="enforceMinMax"
        @focus="moveAmount = 0"
        type="number"
      />
      <ItemGroup
        :inventory="container"
        @start-drag="onDragStart($event, container)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, container)"
        @quick-move="onQuickMove($event, container)"
      />
    </template>
  </main>
</template>

<script lang="ts" setup>
import { Ref, inject, ref } from "vue"; 
import { Inventory } from "./Models/Inventory";
import { Container } from "./Models/Container";
import ItemGroup from "./components/ItemGroup.vue";

let fromInventory: Inventory | null = null;
let fromIndex: number | null = null;
const moveAmount = ref(0);

const inventory = inject<Inventory>("inventory")!;
const container = inject<Container>("container")!;

let selectedInventory: Ref<Inventory | null> = ref(null);
let selectedItemIndex: Ref<number | null> = ref(null);

function getMoveAmount() {  
  return moveAmount.value !== 0 ? moveAmount.value : undefined;
}

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

  fromInventory.MoveItem(
    fromIndex,
    index,
    dropInventory,
    getMoveAmount()
  );
}

function onQuickMove(index: number, fromInventory: Inventory) {
  fromInventory.QuickMoveItem(
    index,
    fromInventory === inventory ? container : inventory,
    getMoveAmount()
  );
}

function onSelectItem(index: number, newSelectedInventory: Inventory) {  
  selectedInventory.value = newSelectedInventory;
  selectedItemIndex.value = index;
}

function enforceMinMax(event: KeyboardEvent) {
  const el = event.target as HTMLInputElement;

  if (el.value != "") {
    if (parseInt(el.value) < parseInt(el.min)) {
      el.value = el.min;
    }
    if (parseInt(el.value) > parseInt(el.max)) {
      el.value = el.max;
    }
  }
}
</script>
