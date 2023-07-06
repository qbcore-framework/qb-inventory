<template>
  <div class="fixed bottom-0 left-0 right-0 flex justify-center items-center">
    <Transition name="fade">
      <div
        v-if="item"
        class="text-white mb-32 flex flex-col bg-gray-200/20 w-fit p-3"
      >
        <img
          class="w-28 h-28 object-contain p-3"
          draggable="false"
          :src="require(`@/assets/images/${item.image}`)"
        />
        <span>{{ message }}</span>
      </div>
    </Transition>
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { Ref, computed, ref } from "vue";

type ItemBoxType = "add" | "remove" | "use";

const item: Ref<Item | null> = ref(null);
const type = ref<ItemBoxType | null>(null);
let timer: number;

window.addEventListener("inventory:item-box", (event) => {
  const { type: etype, item: eitem } = (event as CustomEvent).detail;

  item.value = eitem;
  type.value = etype as ItemBoxType;

  // Remove the item after 2 seconds
  clearTimeout(timer);
  timer = setTimeout(() => {
    item.value = null;
    type.value = null;
  }, 2000);
});

const message = computed(() => {
  if (!item.value) return "";
  switch (type.value) {
    case "add":
      return `Added ${item.value.label}`;
    case "remove":
      return `Removed ${item.value.label}`;
    case "use":
      return `Used ${item.value.label}`;
    default:
      return "";
  }
});
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
