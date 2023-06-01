<template>
  <div>
    <div>
      <h3>{{ weapon.label }}</h3>
      <p v-text="weapon.description" />
      <p>Serial number: {{ weapon.info.serie }}</p>
      <p>Durability: {{ weapon.info.quality }} / {{ Weapon.MAX_QUALITY }}</p>
    </div>

    <img
      :src="require(`@/assets/images/${weapon.image}`)"
      :alt="weapon.label"
    />

    <div v-if="weaponInfo?.AttachmentData?.length">
      <h3>Attachments:</h3>
      <div
        v-for="attachment in weaponInfo.AttachmentData"
        :key="attachment.attachment"
      >
        <span v-text="attachment.label" />
        <img
          :src="
            require(`@/assets/attachment_images/${attachment.attachment}.png`)
          "
          :alt="attachment.label"
        />
        <button
          class="h-12 w-20"
          @click="RemoveAttachment(attachment.attachment)"
        >
          Remove
        </button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { WeaponDataDto } from "@/Models/Dto/GetWeaponData";
import { Weapon } from "@/Models/Item/Weapon";
import { onMounted, ref } from "vue";

const props = defineProps({
  weapon: {
    type: Weapon,
    required: true,
  },
});

const weaponInfo = ref<WeaponDataDto | null>(null);

onMounted(async () => {
  weaponInfo.value = await props.weapon.GetWeaponData();
});

async function RemoveAttachment(attachment: string) {
  props.weapon.RemoveAttachment(attachment);
  // Ideally, updating this value would be done reactively, but I'm not sure how to do that.
  weaponInfo.value = await props.weapon.GetWeaponData();
}
</script>
