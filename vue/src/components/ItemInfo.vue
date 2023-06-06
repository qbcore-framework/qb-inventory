<template>
  <div>
    <h1>Item info panel</h1>
    <pre v-text="hoveredItem?.info" />
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref } from "vue";

const hoveredItem = inject(Item.HOVERED_ITEM, ref<Item | null>(null));
</script>
