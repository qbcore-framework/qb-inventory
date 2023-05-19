<template>
  <!-- Display centered at bottom of screen -->
  <div class="fixed bottom-0 left-0 right-0 flex justify-center">
    <!-- Display hotbar -->
    <div class="flex flex-row" v-if="isOpen">
      <ItemContainer v-for="(item, index) in items" :key="index" :item="item" />
    </div>
  </div>
</template>

<script lang="ts" setup>
import { Hotbar } from "@/Models/Hotbar";
import { inject, ref } from "vue";
import ItemContainer from "./ItemContainer.vue";

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const hotbar = inject<Hotbar>("hotbar")!;
const items = ref(hotbar.items);
const isOpen = ref(hotbar.open);
</script>
