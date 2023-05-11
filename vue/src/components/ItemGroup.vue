<script lang="ts" setup>
import Item from '@/Models/Item';
import { ref } from 'vue';
import ItemContainer from './ItemContainer.vue';
import { Inventory } from '@/Models/Inventory';

defineProps<{
  inventory: Inventory;
}>();

const emit = defineEmits<{
  // eslint-disable-next-line no-unused-vars
  (event: 'itemDropped', index: number): void;
  // eslint-disable-next-line no-unused-vars
  (event: 'startDrag', index: number): void;
  // eslint-disable-next-line no-unused-vars
  (event: 'endDrag'): void;
  // eslint-disable-next-line no-unused-vars
  (event: 'quickMove', index: number): void;
}>();


let draggedIndex = ref<number | null>(null);
let x = ref(0);
let y = ref(0);

function onMouseDown(event: MouseEvent, item: Item, index: number) {
  // Right mouse button
  if (event.button === 2) {
    console.log('right click');
    emit('quickMove', index);
  }
  // Left mouse button
  else if (event.button === 0) {
    if (item === undefined || item === null) return;
    emit('startDrag', index);
  
    draggedIndex.value = index;
  
    // Set initial position and account for mouse offset
    x.value = event.clientX - event.offsetX;
    y.value = event.clientY - event.offsetY;
  
    window.addEventListener('mousemove', onMouseMove);
  }
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
  emit('endDrag');
}

function onItemDropped(event: CustomEvent, otherIndex: number) {
  emit('itemDropped', otherIndex);
}
</script>

<template>
  <div class="item-group">
    <h1>Item Group</h1>
    <div class="grid grid-cols-5 gap-4">
      <div v-for="(item, index) in inventory.Items.value" :key="index">
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