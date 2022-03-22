<template>
    <div class="z-hotbar-inventory">
        <div v-for="index in 6" :key="index" class="z-hotbar-item-slot" :set="slot = index == 6 ? 41 : index" :item="item = items[slot]" :data-zhotbarslot="slot">
            <div class="z-hotbar-item-slot-key">
                <p>{{ index }} <i v-if="slot == 41" class="fas fa-lock"></i></p>
            </div>
            <div class="z-hotbar-item-slot-img">
                <img :src="item.image" :alt="item.name" v-if="item">
            </div>
            <div class="z-hotbar-item-slot-label" v-if="!item || !item.isWeapon">
                <p>{{ !item ? "&nbsp;" : item.label }}</p>
            </div>
            <div class="item-slot-quality" v-if="item && item.isWeapon">
                <div class="item-slot-quality-bar" v-if="item.weaponInfo.label == 'BROKEN'" :style="{width: '100%', backgroundColor: item.weaponInfo.color}">
                    <p>BROKEN</p>
                </div>
                <div class="item-slot-quality-bar" :style="{width: item.weaponInfo.label + '%', backgroundColor: item.weaponInfo.color}">
                    <p>{{ item.weaponInfo.label }}</p>
                </div>
            </div>
            <div class="item-slot-label" v-if="item && item.isWeapon">
                <p>{{ item.label }}</p>
            </div>
            <div class="z-hotbar-item-slot-amount" v-if="item">
                <p>{{ item.amount }} ({{ ((item.weight * item.amount) / 1000).toFixed(1) }})</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ["hotbar"],
    data() {
        return {
            items: {}
        }
    },
    mounted() {
        this.items = {}
        this.hotbar.items.forEach(item => {
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

                itemTreated.weaponInfo = this.setQuality(item, true, false);
                this.items[item.slot] = itemTreated
            }
        });
    },
    methods: {
        setQuality: function(item, IsHotbar, IsOtherInventory) {
            var weaponInfo = null;

            if (!this.IsWeaponBlocked(item.name) && item.name.split("_")[0] == "weapon") {
                weaponInfo = {
                    quality: item.info.quality,
                }

                if (weaponInfo.quality == undefined)
                    weaponInfo.quality = 100;

                // Set weapon status from the quality
                weaponInfo.color = "rgb(39, 174, 96)";
                if (weaponInfo.quality < 25)
                    weaponInfo.color = "rgb(192, 57, 43)";
                else if (weaponInfo.quality > 25 && weaponInfo.quality < 50)
                    weaponInfo.color = "rgb(230, 126, 34)";
                else if (weaponInfo.quality >= 50)
                    weaponInfo.color = "rgb(39, 174, 96)";
                
                // Set the weaponInfo Label to the Quality
                if (weaponInfo.quality !== undefined)
                    weaponInfo.label = weaponInfo.quality.toFixed();
                else
                    weaponInfo.label = weaponInfo.quality;

                if (weaponInfo.quality == 0) {
                    weaponInfo.label = "BROKEN"; /** @todo: need translation support */
                }
            }

            return weaponInfo
        }
    }
}
</script>