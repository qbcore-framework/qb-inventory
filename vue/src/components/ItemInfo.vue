<template>
  <div class="text-white">
    <p class="font-bold" v-text="hoveredItem?.label" />
    <p
      v-for="(info, index) in parseInfo(hoveredItem?.info ?? {})"
      v-text="info"
      v-bind:key="index"
    />
    <p v-text="hoveredItem?.description" />
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref } from "vue";

const hoveredItem = inject(Item.HOVERED_ITEM, ref<Item | null>(null));

function parseInfo(info: object): string[] {
  return Object.entries(info).map(
    ([key, value]) =>
      // Capitalize first letter of key
      `${key.charAt(0).toUpperCase() + key.slice(1)}: ${parseInfoValues(
        key,
        value
      )}`
  );
}

function parseInfoValues(key: string, value: string): string {
  // ID Card genders
  if (key === "gender") {
    return value === "0" ? "female" : "male";
  }

  // If value is a number, return it
  if (!isNaN(Number(value))) {
    return Number(value).toFixed(0);
  }

  return value;
}
</script>
