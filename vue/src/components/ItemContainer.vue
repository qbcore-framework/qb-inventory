<script lang="ts" setup>
import Item from '@/Models/Item';
import { inject, ref } from 'vue';

const props = defineProps<{
  item: Item | undefined;
  index: number;
}>();

const emit = defineEmits<{
  // eslint-disable-next-line no-unused-vars
  (event: 'swap', index: number, otherIndex: number): void;
}>();

const itemContainer = ref<HTMLElement>();
let isUserDragging = inject('isUserDragging', ref(false));
let isItemDragged = ref(false);
let x = ref(0);
let y = ref(0);

function onMouseDown(event: MouseEvent) {
  isUserDragging.value = true;
  isItemDragged.value = true;

  // Set initial position and account for mouse offset
  x.value = event.clientX - event.offsetX;
  y.value = event.clientY - event.offsetY;

  // Register mousemove and mouseup events
  window.addEventListener('mousemove', onMouseMove);
}

function onMouseMove(event: MouseEvent) {
  if (isItemDragged.value) {
    x.value = x.value + event.movementX;
    y.value = y.value + event.movementY;
  }
}

function onMouseUp(event: MouseEvent) {
  window.removeEventListener('mousemove', onMouseMove);
  
  // Hide dragged element so we can get the element which the item is dropped on
  if (itemContainer.value) {
    itemContainer.value.style.display = 'none';
  }
  
  let element = document.elementFromPoint(event.clientX, event.clientY);
  // Get the item container
  while (element && !element.classList.contains('item-container')) {    
    element = element.parentElement;
  }
  

  if (element) element.dispatchEvent(new CustomEvent('item-dropped', { detail: props.index }));

  // Wait for click event to be triggered
  setTimeout(() => {
    isUserDragging.value = false;
    isItemDragged.value = false;
  }, 0);

  if (itemContainer.value) {
    itemContainer.value.style.display = 'block';
  }
}

function onClick() {
  console.log('click unregistered', isUserDragging.value, isItemDragged.value);
  
  // Only trigger swap event from item on which the item is dropped
  if(!isItemDragged.value) {
    console.log('clicked', props.index);
  }
}

function onItemDropped(event: CustomEvent) {
  const otherIndex = event.detail;
  emit('swap', props.index, otherIndex);
}
</script>

<template>
  <div 
    ref="itemContainer"
    class="w-32 h-48 p-2 flex flex-col bg-black z-0 item-container"
    :style="isUserDragging ? `position: absolute; top: ${y}px; left: ${x}px;` : ''"
    @mousedown="onMouseDown"
    @mouseup="onMouseUp"
    @click="onClick"
    @item-dropped="onItemDropped"
    >
    <template v-if="item">
      <span class="text-right">
        {{ item.amount }}
        |
        {{ item.weight }}
      </span>

      <img draggable="false" :src="require(`@/assets/images/${item.image}`)" class="py-2" />

      <span class="text-center">
        {{ item.label }}
      </span>
    </template>
  </div>
</template>