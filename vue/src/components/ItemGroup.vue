<script lang="ts" setup>
import Item from "@/Models/Item";
import { computed, ref } from "vue";
import { Inventory } from "@/Models/Inventory";
import ItemContainer from "./ItemContainer.vue";

interface IProps {
  inventory: Inventory;
  canSelectItems?: boolean;
}

withDefaults(defineProps<IProps>(), {
  canSelectItems: false,
});

const emit = defineEmits<{
  (event: "itemDropped", index: number): void;
  (event: "startDrag", index: number): void;
  (event: "endDrag"): void;
  (event: "quickMove", index: number): void;
  (event: "selectItem", index: number): void;
}>();

const draggedIndex = ref<number | null>(null);
const x = ref(0);
const y = ref(0);

let didMouseMoveSinceMouseDown = false;

function onMouseDown(event: MouseEvent, item: Item, index: number) {
  draggedIndex.value = null;
  // Right mouse button
  if (event.button === 2) {
    emit("quickMove", index);
  }
  // Left mouse button
  else if (event.button === 0) {
    if (item === undefined || item === null) return;
    emit("startDrag", index);

    draggedIndex.value = index;

    // Set the x and y from the mouse position relative to the item container
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    const element = document
      .elementsFromPoint(event.clientX, event.clientY)
      .find((element) => element.classList.contains("item-container"))!;
    const rect = element.getBoundingClientRect();
    const offsetX = event.clientX - rect.left;
    const offsetY = event.clientY - rect.top;

    x.value = event.clientX - offsetX;
    y.value = event.clientY - offsetY;

    didMouseMoveSinceMouseDown = false;
    window.addEventListener("mousemove", onMouseMove);
  }
}

function onMouseMove(event: MouseEvent) {
  if (draggedIndex.value !== null) {
    didMouseMoveSinceMouseDown = true;
    x.value = x.value + event.movementX;
    y.value = y.value + event.movementY;
  }
}

function onMouseUp(event: MouseEvent, index: number) {
  window.removeEventListener("mousemove", onMouseMove);

  // If mouse didn't move since mouse down, then it was a click
  if (!didMouseMoveSinceMouseDown) {
    emit("selectItem", index);
    return;
  }

  const elements = document.elementsFromPoint(event.clientX, event.clientY);

  // Find second item with 'item-container' class
  const element = elements.filter((element) =>
    element.classList.contains("item-container")
  )[1];

  if (element)
    element.dispatchEvent(new CustomEvent("item-dropped", { detail: index }));

  draggedIndex.value = null;
  emit("endDrag");
}

function onItemDropped(event: CustomEvent, otherIndex: number) {
  emit("itemDropped", otherIndex);
}
</script>

<template>
  <div class="item-group">
    <h1>Item Group</h1>
    <div class="grid grid-cols-5 gap-4">
      <div v-for="(item, index) in inventory.Items.value" :key="index">
        <ItemContainer
          :style="
            index === draggedIndex
              ? `position: absolute; top: ${y}px; left: ${x}px;`
              : ''
          "
          class="item-container"
          :item="item"
          :index="index"
          :selected="computed(() => canSelectItems && index === draggedIndex)"
          @mousedown="onMouseDown($event, item, index)"
          @mouseup="onMouseUp($event, index)"
          @item-dropped="onItemDropped($event, index)"
        />
      </div>
    </div>
  </div>
</template>
