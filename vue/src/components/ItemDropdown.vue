<template>
  <div class="fixed top-0 left-0 z-50" ref="dropdown" v-show="show">
    <!-- Blur background with classes -->
    <ItemInfo class="backdrop-blur-lg p-1 border rounded bg-gray-800/30" />
  </div>
</template>

<script lang="ts" setup>
import { Item } from "@/Models/Item/Item";
import { inject, ref, watch } from "vue";
import ItemInfo from "./ItemInfo.vue";

const item = inject(Item.HOVERED_ITEM, ref<Item | null>(null));
const dropdown = ref<HTMLDivElement | null>(null);

const x = ref(0);
const y = ref(0);

function onMouseMove(event: MouseEvent) {
  x.value = event.clientX;
  y.value = event.clientY;
}
window.addEventListener("mousemove", onMouseMove);

// Bind the x and y to the style of the dropdown
watch([x, y], () => {
  if (dropdown.value === null) return;

  dropdown.value.style.left = `calc(${x.value + 10}px + 1em)`;
  dropdown.value.style.top = `calc(${y.value + 10}px - 2em)`;
});

// Delay showing the dropdown
const show = ref(false);
watch(item, () => {
  if (item.value === null) {
    show.value = false;
    return;
  }

  setTimeout(() => {
    if (item.value === null) return;
    show.value = true;
  }, 500);
});
</script>
