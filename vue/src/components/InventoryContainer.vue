<template>
  <div class="flex justify-center">
    <template v-if="inventory.isVisible.value && !showWeaponPanel">
      <ItemGroup
        :inventory="inventory"
        :canSelectItems="true"
        @start-drag="onDragStart($event, inventory)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, inventory)"
        @quick-move="onQuickMove($event, inventory)"
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
      <!-- Container -->
      <ItemGroup
        v-if="container.isVisible.value"
        :inventory="container"
        @start-drag="onDragStart($event, container)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, container)"
        @quick-move="onQuickMove($event, container)"
      />

      <!-- Crafting container -->
      <ItemGroup
        v-if="craftingContainer.isVisible.value"
        :inventory="craftingContainer"
        :canSelectItems="true"
        @start-drag="onDragStart($event, craftingContainer)"
        @end-drag="onDragEnd"
        @item-dropped="onItemDropped($event, craftingContainer)"
        @quick-move="onQuickMove($event, craftingContainer)"
      />
    </template>
    <WeaponPanel
      v-else-if="showWeaponPanel"
      :weapon="(selectedItem as Weapon)"
    />
  </div>
</template>

<script lang="ts" setup>
import { Ref, computed, inject, provide, ref } from "vue";
import { PlayerInventory } from "../Models/Container/PlayerInventory";
import { Container } from "../Models/Container/Container";
import { Weapon } from "../Models/Item/Weapon";
import { Item } from "../Models/Item/Item";
import ItemGroup from "./ItemGroup.vue";
import WeaponPanel from "./WeaponPanel.vue";
import { ContainerBase } from "@/Models/Container/ContainerBase";

let fromInventory: ContainerBase<Item> | null = null;
let fromIndex: number | null = null;
const moveAmount = ref(0);

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const inventory = inject<PlayerInventory>("inventory")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const container = inject<Container>("container")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const craftingContainer = inject<Container>("craftingContainer")!;

provide(Item.SELECTED_ITEM, ref(null));
const selectedItem: Ref<Item | null> = inject(Item.SELECTED_ITEM, ref(null));

const isWeaponSelected = computed(() => selectedItem.value instanceof Weapon);
const showWeaponPanel = ref(false);

window.addEventListener("inventory:close", () => {
  showWeaponPanel.value = false;
});

function getMoveAmount() {
  return moveAmount.value !== 0 ? moveAmount.value : undefined;
}

function onDragStart(index: number, inventory: ContainerBase<Item>) {
  fromInventory = inventory;
  fromIndex = index;
}

function onDragEnd() {
  fromInventory = null;
  fromIndex = null;
}

function onItemDropped(index: number, dropInventory: ContainerBase<Item>) {
  if (fromInventory === null || fromIndex === null) return;

  fromInventory.MoveItem(fromIndex, index, dropInventory, getMoveAmount());
}

function onQuickMove(index: number, fromInventory: ContainerBase<Item>) {
  fromInventory.QuickMoveItem(
    index,
    fromInventory === inventory ? container : inventory,
    getMoveAmount()
  );
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
