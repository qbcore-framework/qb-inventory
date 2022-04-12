<template>
    <div class="itemboxes-container" :style="{width: 'calc(' + itemsShown.length * 5 + 'vw + 10px * ' + itemsShown.length + ')'}">
        <transition-group name="fade">
            <div class="itembox-container" v-for="item in itemsShown.slice().reverse()" :key="item.id">
                <div id="itembox-action">
                    <p>
                        {{ item.type }}
                    </p>
                </div>
                <div id="itembox-label">
                    <p>
                        {{ item.label }}
                    </p>
                </div>
                <div class="item-slot-img">
                    <img :src="item.image" :alt="item.name" />
                </div>
            </div>
        </transition-group>
    </div>
</template>

<style> 
    .fade-enter-active {
        transition: transform .8s ease-in-out, opacity .3s ease-in-out;
    }
    .fade-leave-active {
        transition: transform .8s ease-in-out, opacity .3s ease-in-out;
    }
    .fade-enter-from {
        transform: translateX(-100%) !important;
        opacity: 0 !important;
    }
    .fade-leave-to {
        transform: translateX(100%) !important;
        opacity: 0 !important;
    }
    .fade-move {
        transition: transform .5s ease-in-out;
    }
</style>

<script>
export default {
    data() {
        return {
            itemsShown: [],
            id: 0,
        }
    },
    mounted() {
        this.itemsShown = [];
    },
    methods: {
        AddItemBox: function(data) {
            let type = this.i18n.itemBox.used;
            if (data.type == "add") {
                type = this.i18n.itemBox.received;
            } else if (data.type == "remove") {
                type = this.i18n.itemBox.removed;
            }

            this.itemsShown.push({
                id: this.id++,
                type: type,
                label: data.item.label ,
                image: "images/" + data.item.image ,
                name: data.item.name,
            })
            
            setTimeout(() => this.removeLatestItembox(), 3000); /** @todo add this to a JS Config */
        },
        removeLatestItembox: function() {
            this.itemsShown.shift();
        }
    }
}
</script>