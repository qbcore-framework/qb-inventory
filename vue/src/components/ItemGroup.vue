<script lang="ts" setup>
import Item from '@/Models/Item';
import { ref } from 'vue';
import ItemContainer from './ItemContainer.vue';

defineProps<{
  items: Item[];
}>();

const emit = defineEmits<{
  // eslint-disable-next-line no-unused-vars
  (event: 'swap', index: number, otherIndex: number): void;
}>();


let draggedIndex = ref<number | null>(null);
let x = ref(0);
let y = ref(0);

function onMouseDown(event: MouseEvent, item: Item, index: number) {
  if (item === undefined) return;

  draggedIndex.value = index;

  // Set initial position and account for mouse offset
  x.value = event.clientX - event.offsetX;
  y.value = event.clientY - event.offsetY;

  // Register mousemove and mouseup events
  window.addEventListener('mousemove', onMouseMove);
}

function onMouseMove(event: MouseEvent) {
  if (draggedIndex.value !== null) {
    x.value = x.value + event.movementX;
    y.value = y.value + event.movementY;
  }
}

function onMouseUp(event: MouseEvent, index: number) {
  window.removeEventListener('mousemove', onMouseMove);

  let elements = document.elementsFromPoint(event.clientX, event.clientY);
  
  // Find second item with 'item-container' class
  const element = elements.filter((element) => element.classList.contains('item-container'))[1];

  if (element) element.dispatchEvent(new CustomEvent('item-dropped', { detail: index }));

  draggedIndex.value = null;
}

function onItemDropped(event: CustomEvent, otherIndex: number) {
  const droppedIndex = event.detail;
  emit('swap', droppedIndex, otherIndex);
}
</script>

<template>
  <div class="item-group">
    <h1>Item Group</h1>
    <div class="grid grid-cols-5 gap-4">
      <div v-for="(item, index) in items" :key="index">
        <ItemContainer :style="index === draggedIndex ? `position: absolute; top: ${y}px; left: ${x}px;` : ''"
          class="item-container"
          :item="item" 
          :index="index"
          @mousedown="onMouseDown($event, item, index)"
          @mouseup="onMouseUp($event, index)"
          @item-dropped="onItemDropped($event, index)"
          />
      </div>
    </div>
  </div>
</template>