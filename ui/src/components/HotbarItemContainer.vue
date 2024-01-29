<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { Weapon } from "@/Models/Item/Weapon";

interface IProps {
  item?: Item;
}
defineProps<IProps>();
</script>

<template>
  <div
    class="w-28 h-28 p-2 flex flex-col z-0 relative cursor-pointer ease-in-out transition-transform duration-75 transform text-white bg-gray-800/60"
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
        <span></span>
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
