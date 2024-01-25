<template>
  <div class="flex justify-center">
    <GroundDropBox @item-dropped="onQuickMove($event.detail, inventory)" />
    <TransitionGroup name="fade">
      <template v-if="inventory.isVisible.value && !showWeaponPanel">
        <ItemGroup
          :inventory="inventory"
          :canSelectItems="true"
          @start-drag="onDragStart($event, inventory)"
          @end-drag="onDragEnd"
          @item-dropped="onItemDropped($event, inventory)"
          @quick-move="onQuickMove($event, inventory)"
        />
        <div class="flex flex-col px-4">
          <span class="h-9" />
          <input
            class="h-12 w-20 bg-gray-200/20 text-center no-spinner border outline-none"
            type="number"
            v-model="moveAmount"
            min="0"
            max="1000"
            @keyup="enforceMinMax"
          />
          <button
            class="w-20 h-16 mt-4 border bg-gray-200/20 disabled:bg-black/20 disabled:cursor-default"
            @click="modifyWeapon"
            :disabled="!canModifyWeapon"
            v-text="canModifyWeapon ? 'Modify' : 'Can\'t modify'"
          />
        </div>
        <!-- Container -->
        <ItemGroup
          v-if="container.isVisible.value && !container.isGround()"
          :inventory="container"
          :canSelectItems="false"
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
    </TransitionGroup>
    <GroundDropBox @item-dropped="onQuickMove($event.detail, inventory)" />
    <WeaponPanel
      class="absolute"
      v-if="showWeaponPanel"
      :weapon="selectedItem as Weapon"
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
import GroundDropBox from "./GroundDropBox.vue";

let fromInventory: ContainerBase<Item> | null = null;
const fromIndex: Ref<number | null> = ref(null);
const moveAmount = ref(0);

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const inventory = inject<PlayerInventory>("inventory")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const container = inject<Container>("container")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const craftingContainer = inject<Container>("craftingContainer")!;
provide(
  "showGroundDropBox",
  computed(
    () =>
      container.isVisible.value &&
      container.isGround() &&
      fromIndex.value !== null,
  ),
);

const selectedItem: Ref<Item | null> = inject(Item.SELECTED_ITEM, ref(null));

const canModifyWeapon = computed(
  () =>
    selectedItem.value instanceof Weapon &&
    inventory.Items.value.includes(selectedItem.value),
);

const showWeaponPanel = ref(false);

window.addEventListener("inventory:close", () => {
  showWeaponPanel.value = false;
});

function getMoveAmount() {
  return moveAmount.value !== 0 ? moveAmount.value : undefined;
}

function onDragStart(index: number, inventory: ContainerBase<Item>) {
  fromInventory = inventory;
  fromIndex.value = index;
}

function onDragEnd() {
  fromInventory = null;
  fromIndex.value = null;
}

function onItemDropped(index: number, dropInventory: ContainerBase<Item>) {
  if (fromInventory === null || fromIndex.value === null) return;

  fromInventory.MoveItem(
    fromIndex.value,
    index,
    dropInventory,
    getMoveAmount(),
  );
}

function onQuickMove(index: number, fromInventory: ContainerBase<Item>) {
  fromInventory.QuickMoveItem(
    index,
    fromInventory === inventory ? container : inventory,
    getMoveAmount(),
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

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Remove arrows from number input */
input[type="number"].no-spinner::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
