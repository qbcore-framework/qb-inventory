<script lang="ts" setup>
import Item from '@/Models/Item';
import { ref } from 'vue';

defineProps<{
  item: Item | undefined;
}>();

// eslint-disable-next-line no-unused-vars
let isDragging = ref(false);
let x = ref(0);
let y = ref(0);

function onMouseDown(event: MouseEvent) {
  isDragging.value = true;

  // Set initial position and account for mouse offset
  x.value = event.clientX - event.offsetX;
  y.value = event.clientY - event.offsetY;

  // Register mousemove and mouseup events
  window.addEventListener('mousemove', onMouseMove);
}

function onMouseMove(event: MouseEvent) {
  if (isDragging.value) {
    x.value = x.value + event.movementX;
    y.value = y.value + event.movementY;
  }
}

function onMouseUp() {
  isDragging.value = false;

  // Unregister mousemove and mouseup events
  window.removeEventListener('mousemove', onMouseMove);
}
</script>

<template>
  <div 
    class="w-32 h-48 p-2 flex flex-col bg-black"
    :style="
      isDragging ? `position: absolute; top: ${y}px; left: ${x}px;` : ''
    "
    @mousedown="onMouseDown"
    @mouseup="onMouseUp"
    >
    <template v-if="item">
      <!-- Display right -->
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