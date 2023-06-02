<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref } from "vue";

interface IProps {
  item?: Item;
}
defineProps<IProps>();

const selectedItem = inject(Item.SELECTED_ITEM, ref<Item | null>(null));
</script>

<template>
  <div
    :class="[
      'w-32 h-48 p-2 flex flex-col bg-black z-0',
      selectedItem === item ? 'bg-blue-600' : 'bg-black',
    ]"
  >
    <template v-if="item">
      <span class="text-right">
        {{ item.amount }}
        |
        {{ item.weight }}
      </span>
      <img
        draggable="false"
        :src="require(`@/assets/images/${item.image}`)"
        class="py-2"
      />
      <span class="text-center" v-text="item.label" />
    </template>
    <div v-else></div>
  </div>
</template>
