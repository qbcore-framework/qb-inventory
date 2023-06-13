<template>
  <main
    :class="[
      'w-screen h-screen text-white',
      isDevBrowser() ? 'bg-cover bg-center bg-repeat-space' : '',
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
  <ItemDropdown />
</template>

<script lang="ts" setup>
import InventoryContainer from "@/components/InventoryContainer.vue";
import HotbarContainer from "@/components/HotbarContainer.vue";
import ItemDropdown from "@/components/ItemDropdown.vue";

function isDevBrowser() {
  return (
    process.env.NODE_ENV === "development" &&
    typeof GetParentResourceName === "undefined"
  );
}
</script>
