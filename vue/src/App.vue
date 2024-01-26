<template>
  <div
    v-if="isDevBrowser()"
    :style="{
      background: 'url(' + require('@/mock/background.jpg') + ')',
    }"
    class="w-screen h-screen bg-no-repeat bg-center bg-cover fixed -z-10 blur transform scale-105"
  />
  <div class="h-screen w-screen">
    <main class="w-screen h-screen text-white">
      <InventoryContainer />
    </main>
    <HotbarContainer />
    <ItemDropdown />
    <ItemBox />
  </div>
</template>

<script lang="ts" setup>
import InventoryContainer from "@/components/InventoryContainer.vue";
import HotbarContainer from "@/components/HotbarContainer.vue";
import ItemDropdown from "@/components/ItemDropdown.vue";
import ItemBox from "@/components/ItemBox.vue";

function isDevBrowser() {
  return (
    process.env.NODE_ENV === "development" &&
    typeof GetParentResourceName === "undefined"
  );
}
</script>
