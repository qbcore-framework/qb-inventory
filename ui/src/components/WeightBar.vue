<template>
  <div class="w-full h-6 mb-4 bg-gray-200/20 relative">
    <div class="h-full bg-gray-200/40" ref="bar" />

    <span
      class="absolute top-0 left-0 right-0 bottom-0 flex justify-center items-center"
    >
      {{ usedWeight / 1000 }}kg / {{ props.container.maxWeight.value / 1000 }}kg
    </span>
  </div>
</template>

<script lang="ts" setup>
import { ContainerBase } from "@/Models/Container/ContainerBase";
import { Item } from "@/Models/Item/Item";
import { computed, onMounted, ref, watch } from "vue";

const props = defineProps<{
  container: ContainerBase<Item>;
}>();

const bar = ref<HTMLDivElement | null>(null);

const usedWeight = computed(() =>
  props.container.Items.value.reduce((acc, item) => acc + item.totalWeight, 0),
);

const weightPercentage = computed(() => {
  if (props.container.maxWeight === null) return null;
  return (usedWeight.value / props.container.maxWeight.value) * 100;
});

function updateBar() {
  if (bar.value === null) return;
  bar.value.style.width = `${weightPercentage.value}%`;
}

watch(weightPercentage, updateBar);
onMounted(updateBar);
</script>
