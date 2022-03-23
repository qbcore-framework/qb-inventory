<template>
    <div class="z-hotbar-inventory">
        <item-slot v-for="index in 6" :key="index" class="z-hotbar-item-slot" :set="slot = index == 6 ? 41 : index" inventory="hotbar" :item="item = items[slot]" :data-zhotbarslot="slot"
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
            items: {}
        }
    },
    mounted() {
        this.items = {}
        for (const [slot, item] of Object.entries(this.hotbar.items)) {
            if (item) {
                var itemTreated = {
                    label: item.label,
                    isWeapon: false,
                    image: "images/"+item.image,
                    name: item.name,
                    amount: item.amount,
                    weight: item.weight,
                }

                if (item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name)) {
                    itemTreated.isWeapon = true
                }

                itemTreated.weaponInfo = this.getWeaponInfo(item);
                this.items[item.slot] = itemTreated
            }
        }
    },
}
</script>