<template>
  <div class="flex justify-center">
    <GroundDropBox
      @item-dropped="onQuickMove($event.detail, playerInventory)"
    />
    <TransitionGroup name="fade">
      <div
        v-if="playerInventory.isVisible.value && !showWeaponPanel"
        class="flex mt-24"
      >
        <ItemGroup
          :inventory="playerInventory"
          :canSelectItems="true"
          @start-drag="onDragStart($event, playerInventory)"
          @end-drag="onDragEnd"
          @item-dropped="onItemDropped($event, playerInventory)"
          @quick-move="onQuickMove($event, playerInventory)"
        />
        <div class="flex flex-col px-4">
          <span class="h-9" />
          <input
            class="h-12 w-20 bg-gray-800/60 text-center no-spinner border outline-none"
            type="number"
            v-model="moveAmount"
            min="0"
            max="1000"
            @keyup="enforceMinMax"
          />
          <button
            class="w-20 h-16 py-2 mt-4 disabled:border-gray-400 border bg-gray-800/60 disabled:bg-black/20 disabled:cursor-default"
            @click="modifyWeapon"
            :disabled="!canModifyWeapon"
            v-text="canModifyWeapon ? 'Modify' : 'Can\'t modify'"
          />
          <button
            class="w-20 py-2 mt-4 border bg-gray-800/60"
            v-if="canRobPlayer"
            @click="robPlayer"
          >
            Rob money
          </button>
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
      </div>
    </TransitionGroup>
    <GroundDropBox
      @item-dropped="onQuickMove($event.detail, playerInventory)"
    />
    <!-- Ignore "(selectedItem as Weapon)" part as this seems to break the Vue syntax highlighting in VSCode -->
    <!-- prettier-ignore -->
    <WeaponPanel
      class="absolute"
      v-if="showWeaponPanel && selectedItem"
      :weapon="(selectedItem as Weapon)"
      @close-panel="showWeaponPanel = false"
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
import { ModalPanelPlugin } from "@/plugins/ModalPanelPlugin";
import { ModalButton } from "@/Models/Interfaces/ModalButton";
import { RobMoneyPlugin } from "@/plugins/RobMoneyPlugin";

let fromInventory: ContainerBase<Item> | null = null;
const fromIndex: Ref<number | null> = ref(null);
const moveAmount = ref(0);
const isDragging = ref(false);

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const playerInventory = inject<PlayerInventory>("inventory")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const container = inject<Container>("container")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const craftingContainer = inject<Container>("craftingContainer")!;
// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const modalService = inject<ModalPanelPlugin>(ModalPanelPlugin.SERVICE_NAME)!;

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const robMoneyPlugin = inject<RobMoneyPlugin>(RobMoneyPlugin.SERVICE_NAME)!;

provide(
  "showGroundDropBox",
  computed(
    () =>
      container.isVisible.value &&
      container.isGround() &&
      isDragging.value === true &&
      showWeaponPanel.value === false,
  ),
);

const selectedItem: Ref<Item | null> = inject(Item.SELECTED_ITEM, ref(null));

const canModifyWeapon = computed(
  () =>
    selectedItem.value instanceof Weapon &&
    playerInventory.Items.value.includes(selectedItem.value),
);

const canRobPlayer = robMoneyPlugin.canRobMoney;
function robPlayer() {
  robMoneyPlugin.rob();
}

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
  isDragging.value = true;
}

function onDragEnd() {
  fromInventory = null;
  fromIndex.value = null;
  isDragging.value = false;
}

async function onItemDropped(
  index: number,
  dropInventory: ContainerBase<Item>,
) {
  if (fromInventory === null || fromIndex.value === null) return;

  const toItem = dropInventory.Items.value[index];
  if (
    toItem?.combinable &&
    // Items can only combined if they are in the player's inventory
    fromInventory === playerInventory &&
    dropInventory === playerInventory
  ) {
    // We need to store the current values as they are reset by the time the modal is closed
    const fromIndexValue = fromIndex.value;

    const shouldCombine = await modalService.open(
      "Combine",
      "Are you sure you want to combine these items?",
      [new ModalButton("🔨 Combine", true), new ModalButton("🔁 Swap", false)],
    );

    // Here we use `inventory` instead of `fromInventory` as we asserted that they are the same
    // and the fromInventory is reset by the time the modal is closed
    if (shouldCombine) {
      playerInventory.CombineItems(fromIndexValue, index);
    } else {
      playerInventory.MoveItem(
        fromIndexValue,
        index,
        playerInventory,
        getMoveAmount(),
      );
    }
    return;
  }

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
    fromInventory === playerInventory ? container : playerInventory,
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
  z-index: -1;
}

/* Remove arrows from number input */
input[type="number"].no-spinner::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
