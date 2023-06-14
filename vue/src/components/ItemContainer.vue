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
      'w-28 h-28 p-2 flex flex-col z-0 relative cursor-pointer ease-in-out transition-transform duration-75 transform',
      selectedItem === item ? 'bg-gray-400/20 scale-105' : 'bg-gray-200/20',
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
      <div class="flex justify-between items-end w-full h-full relative z-10">
        <span v-if="item.totalWeight"> {{ item.totalWeight / 1000 }}kg </span>
        <span v-else />
        <span> x{{ item.amount }} </span>
      </div>
      <img
        class="absolute top-0 left-0 right-0 bottom-0 w-full h-full object-contain p-3"
        draggable="false"
        :src="require(`@/assets/images/${item.image}`)"
      />
    </template>
    <div v-else></div>
  </div>
</template>
