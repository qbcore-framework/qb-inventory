<template>
  <div class="text-white">
    <p class="font-bold" v-text="hoveredItem?.label" />
    <p
      v-for="(info, index) in stringifyInfo(hoveredItem?.info ?? {})"
      v-text="info"
      v-bind:key="index"
    />
    <p v-text="hoveredItem?.description" />
    <div class="mt-2" v-if="hoveredItem?.combinable">
      <p>
        Drag any of the following items onto this one to make
        <span class="font-medium">{{ hoveredItem.combinable.reward }}</span
        >:
      </p>
      <ul class="list-disc">
        <li
          v-for="(combinableInfo, index) in hoveredItem.combinable.accept"
          v-text="combinableInfo"
          v-bind:key="index"
          class="ml-5"
        />
      </ul>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref } from "vue";

const hoveredItem = inject(Item.HOVERED_ITEM, ref<Item | null>(null));

function stringifyInfo(info: object): string[] {
  return Object.entries(info).map(
    ([key, value]) =>
      // Capitalize first letter of key
      `${key.charAt(0).toUpperCase() + key.slice(1)}: ${parseInfoValues(
        key,
        value,
      )}`,
  );
}

function stringifyCombinableInfo(combinableInfo: string[]): string {
  // Convert array to comma separated string
  return combinableInfo.join(", ");
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

  // Attachment data currently misses labels for non-permanent attachments
  if (key === "attachments") {
    return "visible in weapon modification menu";
  }

  return value;
}
</script>
