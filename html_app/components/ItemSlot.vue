<template>
    <div :class="prefixClass + 'item-slot'" @mouseenter="$bus.trigger('setInfo', item)" @mouseleave="$bus.trigger('resetInfo')">
        <div :class="prefixClass + 'item-slot-key'" v-if="(inventory == 'player' || inventory == 'hotbar') && (slot < 6 || slot == 41)">
            <p>{{ slot % 7 }}</p>
        </div>
        <div :class="prefixClass + 'item-slot-img'">
            <img :src="item.image" :alt="item.name" v-if="item">
        </div>
        <div class="item-slot-label" v-if="!item || !item.isWeapon" :title="(item ? item.label : '')">
            <p>{{ !item ? "&nbsp;" : shortLabel }}</p>
        </div>
        <div class="item-slot-quality" v-if="item && item.isWeapon">
            <div class="item-slot-quality-bar" v-if="item.weaponInfo.label == 'BROKEN'" :style="{width: '100%', backgroundColor: item.weaponInfo.color}">
                <p>BROKEN</p>
            </div>
            <div class="item-slot-quality-bar" :style="{width: item.weaponInfo.label + '%', backgroundColor: item.weaponInfo.color}">
                <p>{{ item.weaponInfo.label }}</p>
            </div>
        </div>
        <div class="item-slot-quality" v-if="item && item.info">
            <div class="item-slot-quality-bar" :style="{width: useWidth, backgroundColor: useColor}">
                <p>{{ i18n.itemSlot.usages_remaining.replace('%{uses}', item.info.uses) }}</p>
            </div>
        </div>
        <div class="item-slot-label" v-if="item && item.isWeapon">
            <p>{{ item.label }}</p>
        </div>
        <div :class="prefixClass + 'item-slot-amount'" v-if="item && !item.price">
            <p>{{ item.amount }} ({{ ((item.weight * item.amount) / 1000).toFixed(1) }})</p>
        </div>
        <div class="item-slot-amount" v-else-if="item && item.price && inventory == 'shop'">
            <p>{{ i18n.itemSlot.item_shop_currency }}{{ item.price }} ({{ (item.weight / 1000).toFixed(1) }} kg)</p>
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
    computed: {
        shortLabel: function () {
            if (this.item.label.length > 13) {
                return this.item.label.substring(0, 11) + '...';
            }
            return this.item.label;
        },
        useWidth: function () {
            if (this.item.info.uses == 0)
                return '100%';
            return this.item.info.uses * 5 + '%'
        },
        useColor: function () {
            if (this.item.info.uses == 0)
                return "rgb(230, 126, 34)";
            else if (this.item.info.uses == 1 || this.item.info.uses == 2)
                return "rgb(192, 57, 43)";
            return "rgb(39, 174, 96)";
        }
    }
}
</script>