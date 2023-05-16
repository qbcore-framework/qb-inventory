<template>
  <!-- <pre v-text="weapon" /> -->
  <div>
    <!-- <pre v-text="weaponInfo" /> -->

    <img :src="require(`@/assets/images/${weapon.image}`)" :alt="weapon.label">

    <div v-if="weaponInfo.AttachmentData?.length">
      <h3>Attachments:</h3>
      <div v-for="attachment in weaponInfo.AttachmentData" :key="attachment.attachment">
        <span v-text="attachment.label" />
        <img :src="require(`@/assets/attachment_images/${attachment.attachment}.png`)" :alt="attachment.label">
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { Weapon } from '@/Models/Weapon';
import { onMounted, ref } from 'vue';

const props = defineProps({
  weapon: {
    type: Weapon,
    required: true
  }
});

let weaponInfo = ref<any>({});

onMounted(async () => {
  weaponInfo.value = await props.weapon.GetMods();
});

// console.log(weaponInfo);
</script>