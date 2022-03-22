<template>
    <div>
        <player-inventory v-if="inventory.length > 0" :inventories="inventory" />
        <transition name="slide-fade">
            <player-hotbar v-if="hotbar.open" :hotbar="hotbar"/>
        </transition>
        <item-box ref="itemBox"/>
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
import PlayerInventory from './PlayerInventory.vue';
import PlayerHotbar from './PlayerHotbar.vue';
import ItemBox from './ItemBox.vue';

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
        ItemBox
    },
    data() {
        return {
            hide: true,
            count: 0,
            inventory: {},
            hotbar: {show: false}
        }
    },
    mounted() {
        window.addEventListener('keydown', this.handleKeyboardInteractions);
        window.addEventListener("message", this.handleFivemMessages);
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
            console.log(event.data);
            switch (event.data.action) {
                case "open":
                    this.open(event.data);
                    break;
                case "close":
                    this.close()
                    break;
                case "update":
                    // console.log(event.data);
                    // Inventory.Update(event.data);
                    break;
                case "itemBox":
                    this.$refs.itemBox.AddItemBox(event.data);
                    break;
                case "requiredItem":
                    // Inventory.RequiredItem(event.data);
                    break;
                case "toggleHotbar":
                    this.hotbar = event.data;
                    break;
                case "RobMoney":
                    // $(".inv-options-list").append(
                    //     '<div class="inv-option-item" id="rob-money"><p>TAKE MONEY</p></div>'
                    // );
                    // $("#rob-money").data("TargetId", event.data.TargetId);
                    break;
            }
        },
        open(data) {
            this.hide = false;
            this.inventory = data;
        },
        close() {
            this.hide = true;
            axios.post("https://qb-inventory/CloseInventory", {});
        },
    },
}
</script>
