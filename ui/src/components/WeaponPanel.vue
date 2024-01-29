<template>
  <div class="flex flex-col items-center relative">
    <button
      class="absolute top-0 right-0 w-8 h-8 bg-gray-800/60 hover:bg-gray-200/40 border"
      @click="$emit('close-panel')"
    >
      X
    </button>
    <div class="w-96 flex justify-center flex-col space-y-2">
      <div>
        <h3 class="text-5xl mb-2" v-text="weapon.label" />
        <p v-text="weapon.description" />
        <span class="font-medium">Serial number: </span>
        <span> {{ weapon.info.serie }}</span>
      </div>

      <img
        :src="require(`@/assets/attachment_images/${weapon.image}`)"
        :alt="weapon.label"
        class="w-max"
      />
      <div class="relative bg-gray-800/60 w-full h-4">
        <div
          :style="{
            width: weapon.info.quality + '%',
          }"
          class="absolute bottom-0 left-0 right-0 bg-green-600 h-full z-50"
        />
      </div>

      <div class="space-y-2">
        <span class="font-medium">Permanent attachments:</span>
        <div
          v-for="attachment in getStaticAttachments()"
          :key="attachment.item"
        >
          <li
            class="list-disc"
            v-if="attachment.label"
            v-text="attachment.label"
          />
        </div>
      </div>

      <div class="pb-2" v-if="weaponInfo?.AttachmentData?.length">
        <span class="font-medium">Removable attachments:</span>
      </div>
    </div>
    <div v-if="weaponInfo?.AttachmentData?.length" class="flex">
      <div
        v-for="attachment in weaponInfo.AttachmentData"
        :key="attachment.attachment"
      >
        <span v-text="attachment.label" />
        <img
          :src="require(`@/assets/images/${attachment.attachment}.png`)"
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

defineEmits(["close-panel"]);

const weaponInfo = ref<WeaponDataDto | null>(null);

onMounted(async () => {
  weaponInfo.value = await props.weapon.GetWeaponData();
});

function getStaticAttachments() {
  return props.weapon.info.attachments;
}

async function RemoveAttachment(attachment: string) {
  props.weapon.RemoveAttachment(attachment);
  // Ideally, updating this value would be done reactively, but I'm not sure how to do that.
  weaponInfo.value = await props.weapon.GetWeaponData();
}
</script>
