<template>
    <div>
        <attachment-menu />
        <player-inventory v-if="!hide" :inventories="inventory" :robbery="robberyTarget" />
        <transition name="slide-fade">
            <player-hotbar v-if="hotbar.open" :hotbar="hotbar"/>
        </transition>
        <item-box ref="itemBox"/>
        <required-items v-if="reqItems" :reqItemsData="reqItems"/>
    </div>
</template>

<style scoped>
    .slide-fade-enter-active {
        transition: all .2s ease-in-out;
    }
    .slide-fade-leave-active {
        transition: all .2s ease-in-out;
    }
    .slide-fade-enter-from, .slide-fade-leave-to {
        transform: translateY(100px);
    }
</style>

<script>
import PlayerInventory from './components/PlayerInventory.vue';
import PlayerHotbar from './components/PlayerHotbar.vue';
import ItemBox from './components/ItemBox.vue';
import AttachmentMenu from './components/AttachmentMenu.vue';
import RequiredItems from './components/RequiredItems.vue';

const axios = require('axios').default;

// Import images to be used in build
function importAll(r) {
  return r.keys().map(r);
}
importAll(require.context('./ammo_images', false, /\.(png|jpg)$/));
importAll(require.context('./attachment_images', false, /\.(png|jpg)$/));
importAll(require.context('./images', false, /\.(png|jpg)$/));

export default {
    components: {
        PlayerInventory,
        PlayerHotbar,
        ItemBox,
        AttachmentMenu,
        RequiredItems
    },
    data() {
        return {
            hide: true,
            showAttachments: false,
            count: 0,
            inventory: {},
            hotbar: {show: false},
            reqItems: null,
            robberyTarget: null,
        }
    },
    mounted() {
        window.addEventListener('keydown', this.handleKeyboardInteractions);
        window.addEventListener("message", this.handleFivemMessages);

        this.$bus.on('enableAttachments', (data) => {
            this.showAttachments = true;
        })

        this.$bus.on('close', () => {
            this.close();
        })
    },
    destroyed() {
        window.removeEventListener('keydown', this.handleKeyboardInteractions);
        window.removeEventListener("message", this.handleFivemMessages);
    },
    methods: {
        handleKeyboardInteractions(event) {
            if (event.repeat)
                return;
            switch (event.code) {
                case "Escape": // ESC
                case "Tab": // TAB
                    this.close();
                    break;
                case "ControlLeft": // Ctrl left
                    this.close();
                    break;
            }
        },
        handleFivemMessages(event) {
            switch (event.data.action) {
                case "open":
                    this.reqItems = null;
                    this.open(event.data);
                    break;
                case "close":
                    this.close()
                    break;
                case "update":
                    this.$bus.trigger('updateInventory', event.data);
                    if (event.data.error)
                        axios.post("https://qb-inventory/PlayDropFail", {}, this.AXIOS_CONFIG);
                    break;
                case "itemBox":
                    this.$refs.itemBox.AddItemBox(event.data);
                    break;
                case "requiredItem":
                    if (!event.data.toggle) {
                        this.reqItems = null;
                        return;
                    }
                    this.reqItems = event.data;
                    break;
                case "toggleHotbar":
                    this.hotbar = event.data;
                    break;
                case "RobMoney":
                    this.robberyTarget = event.data.TargetId;
                    break;
            }
        },
        open(data) {
            this.hide = false;
            this.inventory = data;
            if (this.inventory.error) {
                axios.post("https://qb-inventory/PlayDropFail", {}, this.AXIOS_CONFIG);
            }
        },
        close() {
            this.hide = true;
            this.showAttachments = false;
            this.inventory = {};
            this.robberyTarget = null;
            this.$bus.trigger('disableAttachments');
            axios.post("https://qb-inventory/CloseInventory", {});
        },
    },
}
</script>
