<template>
  <!-- Display centered at bottom of screen -->
  <div class="fixed bottom-0 left-0 right-0 flex justify-center">
    <Transition>
      <div class="flex flex-row space-x-4" v-if="isOpen">
        <HotbarItemContainer
          v-for="(item, index) in items"
          :key="index"
          :item="item"
        />
      </div>
    </Transition>
  </div>
</template>

<script lang="ts" setup>
import { Hotbar } from "@/Models/Hotbar";
import { inject, ref } from "vue";
import HotbarItemContainer from "./HotbarItemContainer.vue";

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const hotbar = inject<Hotbar>("hotbar")!;
const items = ref(hotbar.items);
const isOpen = ref(hotbar.open);
</script>

<style scoped>
.v-enter-active,
.v-leave-active {
  transition: opacity 0.2s ease;
}

.v-enter-from,
.v-leave-to {
  opacity: 0;
}
</style>
