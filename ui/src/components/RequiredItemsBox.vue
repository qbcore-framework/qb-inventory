<template>
  <Transition name="fade">
    <div
      v-if="isVisible"
      class="fixed bottom-0 left-0 right-0 flex justify-center items-center space-x-4"
    >
      <div
        v-for="item in items"
        :key="item.item"
        class="text-white mb-32 flex flex-col bg-gray-200/20 w-fit p-3"
      >
        <img
          class="w-28 h-28 object-contain p-3"
          draggable="false"
          :src="require(`@/assets/images/${item.image}`)"
        />
        <span class="text-center">{{ item.label }}</span>
      </div>
    </div>
  </Transition>
</template>

<script lang="ts" setup>
import { RequiredItemsPlugin } from "@/plugins/RequiredItemsPlugin";
import { inject } from "vue";

// eslint-disable-next-line @typescript-eslint/no-non-null-assertion
const requiredItemsPlugin = inject<RequiredItemsPlugin>(
  RequiredItemsPlugin.SERVICE_NAME,
)!;

const items = requiredItemsPlugin.requiredItems;
const isVisible = requiredItemsPlugin.isVisible;
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
