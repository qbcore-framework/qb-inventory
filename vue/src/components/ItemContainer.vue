<script lang="ts" setup>
import Item from '@/Models/Item';
import { Ref, ref } from 'vue';

interface IProps {
  item: Item;
  selected?: Ref<boolean>;
}

withDefaults(defineProps<IProps>(), {
  selected: () => ref(false),
})

</script>

<template>
  <div :class="[
    'w-32 h-48 p-2 flex flex-col bg-black z-0',
    selected.value ? 'bg-blue-600' : 'bg-black'
    ]">
    <template v-if="item">
      <span class="text-right">
        {{ item.amount }}
        |
        {{ item.weight }}
      </span>
      <img draggable="false" :src="require(`@/assets/images/${item.image}`)" class="py-2" />
      <span class="text-center" v-text="item.label" />
    </template>
  </div>
</template>