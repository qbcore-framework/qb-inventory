<template>
  <main class="w-screen h-screen text-white bg-gray-900 bg-opacity-30">
    <InventoryContainer />
  </main>
  <HotbarContainer />
</template>

<script lang="ts" setup>
import InventoryContainer from "./components/InventoryContainer.vue";
import HotbarContainer from "./components/HotbarContainer.vue";
</script>
