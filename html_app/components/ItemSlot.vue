<template>
    <div class="item-slot">
        <div :class="prefixClass + 'item-slot-key'" v-if="(inventory == 'player' || inventory == 'hotbar') && (slot < 6 || slot == 41)">
            <p>{{ slot % 7 }}</p>
        </div>
        <div :class="prefixClass + 'item-slot-img'">
            <img :src="item.image" :alt="item.name" v-if="item">
        </div>
        <div :class="prefixClass + 'item-slot-label'" v-if="!item || !item.isWeapon">
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
        <div :class="prefixClass + 'item-slot-amount'" v-if="item && !item.price">
            <p>{{ item.amount }} ({{ ((item.weight * item.amount) / 1000).toFixed(1) }})</p>
        </div>
        <div class="item-slot-amount" v-else-if="item && item.price && inventory == 'itemshop'">
            <p>{{ '$' }}{{ item.price }} ({{ (item.weight / 1000).toFixed(1) }}kg)</p>
        </div>
    </div>
</template>

<script>
export default {
    props: ['item', 'slot', 'inventory', 'prefix'],
    data() {
        return {
            prefixClass: this.prefix ? this.prefix : ""
        }
    },
}
</script>