<template>
  <main
    :class="[
      'w-screen h-screen text-white bg-gray-900 bg-opacity-30 overflow-y-scroll',
      isDevBrowser() ? 'bg-cover bg-center' : '',
    ]"
    :style="
      isDevBrowser()
        ? `background: url(${require('@/mock/background.jpg')})`
        : ''
    "
  >
    <InventoryContainer />
  </main>
  <HotbarContainer />
</template>

<script lang="ts" setup>
import InventoryContainer from "./components/InventoryContainer.vue";
import HotbarContainer from "./components/HotbarContainer.vue";

function isDevBrowser() {
  return (
    process.env.NODE_ENV === "development" &&
    typeof GetParentResourceName === "undefined"
  );
}
</script>
