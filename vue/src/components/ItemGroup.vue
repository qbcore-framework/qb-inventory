<script lang="ts" setup>
import Item from '@/Models/Item';
import ItemContainer from './ItemContainer.vue';

defineProps<{
  items: Item[];
}>();

const emit = defineEmits<{
  // eslint-disable-next-line no-unused-vars
  (event: 'swap', index: number, otherIndex: number): void;
}>();

function onDragStart(event: DragEvent, index: number) {
  // Store index in dataTransfer
  event.dataTransfer?.setData('text/plain', index.toString());
}

function onDrop(event: DragEvent, index: number) {
  event.preventDefault();
  const otherIndex = event.dataTransfer?.getData('text/plain');
  emit('swap', index, parseInt(otherIndex!))
}

</script>

<template>
  <div>
    <h1>Item Group</h1>
    <div
      class="grid grid-cols-5 gap-4"
      >
      <div v-for="(item, index) in items" :key="index">
        <ItemContainer :item="item"
          draggable="true"
          dropzone="move"
          @drop="onDrop($event, index)"
          @dragstart="onDragStart($event, index)"
          @dragover="event => event.preventDefault()"
         />
      </div>
    </div>
  </div>
</template>