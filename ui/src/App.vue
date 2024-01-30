<template>
  <div
    v-if="isDevBrowser"
    :style="{
      background: 'url(' + require('@/mock/background.jpg') + ')',
    }"
    class="w-screen h-screen bg-no-repeat bg-center bg-cover fixed -z-10 blur transform scale-105"
  />
  <div>
    <main class="text-white">
      <InventoryContainer />
    </main>
    <HotbarContainer />
    <ItemDropdown />
    <ItemBox />
    <RequiredItemsBox />
  </div>
  <ModalPanel />
</template>

<script lang="ts" setup>
import InventoryContainer from "@/components/InventoryContainer.vue";
import HotbarContainer from "@/components/HotbarContainer.vue";
import ItemDropdown from "@/components/ItemDropdown.vue";
import ItemBox from "@/components/ItemBox.vue";
import ModalPanel from "./components/ModalPanel.vue";
import RequiredItemsBox from "./components/RequiredItemsBox.vue";
import { ref } from "vue";

// This is a hacky way to check if we're in a dev environment
const isDevBrowser = ref(false);
async function checkIfDevBrowser(): Promise<boolean> {
  if (process.env.NODE_ENV === "development") {
    try {
      await fetch("https://qb-inventory/");
      return false;
    } catch (e) {
      return true;
    }
  } else {
    return false;
  }
}
checkIfDevBrowser().then((result) => {
  isDevBrowser.value = result;
});
</script>
