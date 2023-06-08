<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { Weapon } from "@/Models/Item/Weapon";
import { inject, ref } from "vue";

interface IProps {
  item?: Item;
}
const props = defineProps<IProps>();

const hoveredItem = inject(Item.HOVERED_ITEM, ref<Item | null>(null));
const selectedItem = inject(Item.SELECTED_ITEM, ref<Item | null>(null));

function onMouseEnter() {
  hoveredItem.value = props.item ?? null;
}
function onMouseLeave() {
  if (hoveredItem.value === props.item) hoveredItem.value = null;
}
</script>

<template>
  <div
    :class="[
      'w-32 h-32 p-2 flex flex-col bg-gray-200/20 z-0 relative',
      selectedItem === item ? 'bg-blue-600' : '',
      hoveredItem === item ? 'z-10' : '',
    ]"
    @mouseenter="onMouseEnter"
    @mouseleave="onMouseLeave"
  >
    <div
      v-if="item instanceof Weapon"
      :style="{
        height: item.info.quality + '%',
      }"
      class="absolute bottom-0 left-0 right-0 bg-green-600 w-2"
    />
    <template v-if="item">
      <div class="flex justify-between items-end w-full h-full relative">
        <span> {{ item.weight }}kg </span>
        <span> x{{ item.amount }} </span>
      </div>
      <img
        class="absolute top-0 left-0 right-0 bottom-0 w-full h-full object-contain p-6"
        draggable="false"
        :src="require(`@/assets/images/${item.image}`)"
      />
      <!-- <span class="text-center" v-text="item.label" /> -->
    </template>
    <div v-else></div>
  </div>
</template>
