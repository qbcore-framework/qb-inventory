<template>
  <main
    class="w-screen h-screen text-white flex justify-center bg-gray-900 bg-opacity-30"
  >
    <template v-if="inventory.IsVisible.value && !showWeaponPanel">
      <ItemGroup
        :inventory="inventory"
        :canSelectItems="true"
        @start-drag="onDragStart($event, inventory)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, inventory)"
        @quick-move="onQuickMove($event, inventory)"
        @select-item="onSelectItem($event, inventory)"
      />
      <div class="flex-col">
        <input
          class="h-12 w-20 text-black"
          v-model.number="moveAmount"
          min="0"
          max="100"
          @keyup="enforceMinMax"
          @focus="moveAmount = 0"
          type="number"
        />
        <button
          class="h-12 w-20"
          @click="modifyWeapon"
          :disabled="!isWeaponSelected"
          v-text="isWeaponSelected ? 'Modify' : 'Not a weapon'"
        />
      </div>
      <ItemGroup
        :inventory="container"
        @start-drag="onDragStart($event, container)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, container)"
        @quick-move="onQuickMove($event, container)"
      />
    </template>
    <WeaponPanel v-else-if="showWeaponPanel" :weapon="(selectedItem as Weapon)"/>
  </main>
</template>

<script lang="ts" setup>
import { Ref, computed, inject, ref } from "vue"; 
import { Inventory } from "./Models/Inventory";
import { Container } from "./Models/Container";
import { Weapon } from "./Models/Weapon";
import Item from "./Models/Item";
import ItemGroup from "./components/ItemGroup.vue";
import WeaponPanel from "./components/WeaponPanel.vue";

let fromInventory: Inventory | null = null;
let fromIndex: number | null = null;
const moveAmount = ref(0);

const inventory = inject<Inventory>("inventory")!;
const container = inject<Container>("container")!;

let selectedInventory: Ref<Inventory | null> = ref(null);
let selectedItem: Ref<Item | null> = ref(null);

const isWeaponSelected = computed(() => selectedItem.value instanceof Weapon);
let showWeaponPanel = ref(false);

window.addEventListener("inventory:close", () => {
  showWeaponPanel.value = false;
});

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
  selectedItem.value = newSelectedInventory.Items.value[index];
}

function modifyWeapon() {
  if (!selectedItem.value) return;
  showWeaponPanel.value = true;
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
