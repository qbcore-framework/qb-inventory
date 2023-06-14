<template>
  <div class="w-full h-4 mb-4 flex flex-col bg-red-400">
    <div class="h-full bg-red-600" ref="bar" />
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

const weightPercentage = computed(() => {
  const itemWeight = props.container.Items.value.reduce(
    (acc, item) => acc + item.weight * item.amount,
    0
  );

  return (itemWeight / props.container.maxWeight.value) * 100;
});

function updateBar() {
  if (bar.value === null) return;
  bar.value.style.width = `${weightPercentage.value}%`;
}

watch(weightPercentage, updateBar);
onMounted(updateBar);
</script>
