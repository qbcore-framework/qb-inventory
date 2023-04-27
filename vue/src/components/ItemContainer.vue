<script lang="ts" setup>
import Item from '@/Models/Item';

defineProps<{
  item: Item;
}>();

</script>

<template>
  <div class="w-32 h-48 p-2 flex flex-col bg-black z-0">
    <template v-if="item">
      <span class="text-right">
        {{ item.amount }}
        |
        {{ item.weight }}
      </span>
      <img draggable="false" :src="require(`@/assets/images/${item.image}`)" class="py-2" />
      <span class="text-center" v-text="item.label" />
    </template>
  </div>
</template>