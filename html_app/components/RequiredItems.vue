<template>
    <div class="requiredItem-container" v-if="items">
        <div class="requiredItem-box" v-for="(item, index) in items" :key="index">
            <div id="requiredItem-action">{{ i18n.requiredItem.required }}</div>
            <div id="requiredItem-label"><p>{{ item.label }}</p></div>
            <div id="requiredItem-image">
                <div class="item-slot-img">
                    <img :src="'images/' + item.image" :alt="item.name" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ["reqItemsData"],
    data() {
        return {
            requiredTimeout: null,
            items: null,
        }
    },
    mounted() {
        if (this.requiredTimeout !== null) {
            clearTimeout(this.requiredTimeout);
        }

        if (this.reqItemsData.toggle) {
            this.items = this.reqItemsData.items
        } else {
            this.requiredTimeout = setTimeout(() => {
                this.items = null;
            }, 100);
        }
    }
}
</script>