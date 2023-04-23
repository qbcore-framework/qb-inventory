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

function onSwap(index: number, otherIndex: number) {
  emit('swap', index, otherIndex);
}
</script>

<template>
  <div>
    <h1>Item Group</h1>
    <div
      class="grid grid-cols-5 gap-4"
      >
      <div v-for="(item, index) in items" :key="index">
        <ItemContainer
          :item="item"
          :index="index"
          @swap="onSwap"
          />
      </div>
    </div>
  </div>
</template>