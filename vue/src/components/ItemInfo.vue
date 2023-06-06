<template>
  <div>
    <h1>Item info panel</h1>
    <pre v-text="selectedItem?.info" />
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref } from "vue";

const selectedItem = inject(Item.SELECTED_ITEM, ref<Item | null>(null));
</script>
