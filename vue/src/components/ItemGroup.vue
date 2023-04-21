<script lang="ts" setup>
import Item from '@/Models/Item';
import { defineProps } from 'vue';

defineProps<{
  items: Item[];
}>();
</script>

<template>
  <div>
    <h1>Item Group</h1>
    <div v-for="item in items" :key="item.id">
      {{ item.name }}
      <!-- <Item :item="item" /> -->
    </div>
  </div>
</template>