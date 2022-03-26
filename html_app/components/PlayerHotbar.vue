<template>
    <div class="z-hotbar-inventory">
        <item-slot v-for="index in 6" :key="index" :set="slot = index == 6 ? 41 : index" inventory="hotbar" :item="item = items[slot]" :data-zhotbarslot="slot"
            :slot="slot"
            prefix="z-hotbar-">
        </item-slot>
    </div>
</template>

<script>
import ItemSlot from './ItemSlot.vue';
export default {
  components: { ItemSlot },
    props: ["hotbar"],
    data() {
        return {
            id: 0,
            items: {}
        }
    },
    mounted() {
        this.items = {}
        for (const [slot, item] of Object.entries(this.hotbar.items)) {
            if (item) {
                this.items[item.slot] = this.convertItemFromQB(this.id++, item, "hotbar", "hotbar")
            }
        }
    },
}
</script>