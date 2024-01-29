<template>
  <Transition>
    <div
      v-if="showGroundDropBox"
      class="grow bg-gray-200/10 m-4 item-container text-center flex justify-center items-center"
    >
      <span class="text-gray-200">
        Drag you items here to drop them on the ground
      </span>
    </div>
  </Transition>
</template>

<script lang="ts" setup>
import { Ref, inject } from "vue";

const showGroundDropBox = inject<Ref<boolean>>("showGroundDropBox");
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
