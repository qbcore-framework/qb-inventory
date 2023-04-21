<script lang="ts" setup>
import Item from '@/Models/Item';
import ItemContainer from './ItemContainer.vue';

defineProps<{
  items: Item[];
}>();

function onDragStart(event: DragEvent, item: Item) {
  event.dataTransfer?.setData('text/plain', JSON.stringify(item));
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
          @dragstart="onDragStart($event, item)"
         />
      </div>
    </div>
  </div>
</template>