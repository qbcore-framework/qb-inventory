<template>
    <div>
        <div id="qbcore-inventory">
            <div class="inventory-info">
                <div class="player-inv-info">
                    <span id="player-inv-label">Player Inventory</span><br>
                    <span id="player-inv-weight">
                        ⚖️: {{ (totalWeight / 1000).toFixed(2) }} / {{ (playerInventory.maxweight / 1000).toFixed(2) }}
                    </span>
                </div>
                <div class="other-inv-info">
                    <span id="other-inv-label">{{ openedInventory.label }}</span><br>
                    <span id="other-inv-weight" v-if="!isDisableDropInventory(openedInventory.type)">
                        ⚖️: {{ (totalWeightOther / 1000).toFixed(2) }} / {{ (openedInventory.maxweight / 1000).toFixed(2) }}
                    </span>
                </div>
            </div>

            <div class="inv-container" ref="global">
                <div class="ply-inv-container">
                    <div class="player-inventory" data-inventory="player">
                        <div v-for="slot in playerInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :item="item = getInventoryItemAtSlot(TYPE_ITEM_PLAYER_INVENTORY, slot)"
                            :class="{ 'item-slot': true, 'draggable': !(!item) }"
                            @mousedown.left.prevent="startDrag($event, TYPE_ITEM_PLAYER_INVENTORY, slot)"
                            ref="slotPlayer">
                            <div class="item-slot-key" v-if="slot < 6 || slot == 41">
                                <p>{{ slot % 7 }}</p>
                            </div>
                            <div class="item-slot-img">
                                <img :src="item.image" :alt="item.name" v-if="item">
                            </div>
                            <div class="item-slot-label" v-if="!item || !item.isWeapon">
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
                            <div class="item-slot-amount" v-if="item">
                                <p>{{ item.amount }} ({{ ((item.weight * item.amount) / 1000).toFixed(1) }})</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="inv-options">
                    <div class="inv-options-list">
                        <input type="number" id="item-amount" v-model="amount" class="inv-option-item" min="0"/>
                        <div class="inv-option-item" ref="useAction"><p>USE</p></div>
                        <div class="inv-option-item" ref="giveAction"><p>GIVE</p></div>
                        <div class="inv-option-item" @click.prevent="$bus.trigger('close')" id="inv-close"><p>CLOSE</p></div>
                    </div>
                </div>
                <div class="oth-inv-container">
                    <div class="other-inventory" :data-inventory="openedInventory.name">
                        <div :class="{ 'item-slot': true }"
                            v-for="slot in openedInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :style="[openedInventory.type == 'drop' ? {backgroundColor: 'rgba(0, 0, 0, 0.3)'} : '' ]"
                            :item="itemOther = getInventoryItemAtSlot(TYPE_ITEM_OPEN_INVENTORY, slot)"
                            @mousedown.left.prevent="startDrag($event, TYPE_ITEM_OPEN_INVENTORY, slot)"
                            ref="slotOther">
                            <div class="item-slot-img">
                                <img :src="itemOther.image" :alt="itemOther.name" v-if="itemOther">
                            </div>
                            <div class="item-slot-label" v-if="!itemOther || !itemOther.isWeapon">
                                <p>{{ !itemOther ? "&nbsp;" : itemOther.label }}</p>
                            </div>
                            <div class="item-slot-quality" v-if="itemOther && itemOther.isWeapon">
                                <div class="item-slot-quality-bar" v-if="itemOther.weaponInfo.label == 'BROKEN'" :style="{width: '100%', backgroundColor: itemOther.weaponInfo.color}">
                                    <p>BROKEN</p>
                                </div>
                                <div class="item-slot-quality-bar" :style="{width: itemOther.weaponInfo.label + '%', backgroundColor: itemOther.weaponInfo.color}">
                                    <p>{{ itemOther.weaponInfo.label }}</p>
                                </div>
                            </div>
                            <div class="item-slot-label" v-if="itemOther && itemOther.isWeapon">
                                <p>{{ itemOther.label }}</p>
                            </div>
                            <div class="item-slot-amount" v-if="itemOther && !itemOther.price">
                                <p>{{ itemOther.amount }} ({{ ((itemOther.weight * itemOther.amount) / 1000).toFixed(1) }})</p>
                            </div>
                            <div class="item-slot-amount" v-else-if="itemOther.price">
                                <p>{{ '$' }}{{ itemOther.price }} ({{ (itemOther.weight / 1000).toFixed(1) }}kg)</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="ply-hotbar-inventory" data-inventory="hotbar"></div>
            <div class="ply-iteminfo-container">
                <div class="ply-iteminfo">
                    <div class="iteminfo-content">
                        <div class="item-info-title"></div>
                        <div class="item-info-line"></div>
                        <div class="item-info-description"></div>
                    </div>
                </div>
            </div>
            <div class="inv-background"></div>
        </div>
    </div>
</template>

<style scoped>
.inv-option-item {
    cursor: default;
}
#inv-close {
    cursor: pointer;
}
</style>

<script>
import axios from 'axios';

const INVENTORY_TYPE_DISABLE_DROP = ['itemshop', 'crafting']
const AXIOS_CONFIG = { headers: {'Content-Type': 'application/json'} };

/**
 * Component to manage every inventory (or "tab") part
 * 
 * @todo Add Language support on HTML side
 * @todo Add Item in component (it's actually a mess)
 * @todo Add mousedown on actions buttons
*/
export default {
    props: ['inventories'],
    data() {
        return {
            id: 0,
            items: [],
            isDragging: false,
            draggedItem: null,
            playerInventory: {
                slots: 0,
                maxweight: 0,
            },
            openedInventory: {
                name: 0,
                slots: 30,
                label: "Drop",
                type: "drop",
                maxweight: 100000,
            },
            amount: 0,
            TYPE_ITEM_PLAYER_INVENTORY: "player",
            TYPE_ITEM_OPEN_INVENTORY: "other",
            INVENTORY_TYPE_DISABLE_DROP: INVENTORY_TYPE_DISABLE_DROP
        }
    },
    mounted () {
        this.playerInventory.slots = this.inventories.slots;
        this.playerInventory.maxweight = this.inventories.maxweight;
        
        if (this.inventories.other != null && this.inventories.other != "") {
            this.openedInventory.name = this.inventories.other.name;
            this.openedInventory.slots = this.inventories.other.slots;
            this.openedInventory.type = this.inventories.other.name.split('-')[0];
            this.openedInventory.label = this.inventories.other.label;
            this.openedInventory.maxweight = this.inventories.other.maxweight;
        }

        if (this.inventories.inventory !== null) {
            for (const [slot, item] of Object.entries(this.inventories.inventory)) {
                if (item != null) {
                    /** @todo Add the common function to share with others component */
                    this.items.push({
                        id: this.id++,
                        name: item.name,
                        label: item.label,
                        type: item.name.split("_")[0],
                        inventory: this.TYPE_ITEM_PLAYER_INVENTORY,
                        inventoryType: this.TYPE_ITEM_PLAYER_INVENTORY,
                        amount: item.amount,
                        weight: item.weight,
                        slot: item.slot,
                        image: "images/" + item.image,
                        isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
                        weaponInfo: this.getWeaponInfo(item)
                    })
                }
            }
        }

        if (this.inventories.other != null && this.inventories.other != "" && this.inventories.other.inventory != null) {

            for (const [slot, item] of Object.entries(this.inventories.other.inventory)) {
                if (item != null) {
                    /** @todo Add the common function to share with others component */
                    this.items.push({
                        id: this.id++,
                        name: item.name,
                        label: item.label,
                        type: item.name.split("_")[0],
                        inventory: this.TYPE_ITEM_OPEN_INVENTORY,
                        inventoryType: this.openedInventory.name,
                        amount: item.amount,
                        weight: item.weight,
                        slot: item.slot,
                        image: "images/" + item.image,
                        isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
                        weaponInfo: this.getWeaponInfo(item)
                    })
                }
            }
        }

        this.setDefaultAmountValue();
    },
    computed: {
        playerItemInventory() {
            return this.items.filter((item) => item.inventory == this.TYPE_ITEM_PLAYER_INVENTORY);
        },
        openedItemInventory() {
            return this.items.filter((item) => item.inventory == this.TYPE_ITEM_OPEN_INVENTORY);
        },

        totalWeight: function () {
            return this.playerItemInventory.reduce((weight, item) => {
                return weight + (item.weight * item.amount);
            }, 0)
        },
        totalWeightOther: function () {
            return this.openedItemInventory.reduce((weight, item) => {
                return weight + (item.weight * item.amount);
            }, 0)
        }
    },
    methods: {
        isDisableDropInventory(inventory) {
            return INVENTORY_TYPE_DISABLE_DROP.includes(inventory);
        },
        getInventoryItemAtSlot: function(inventory, slot) {
            var selectedItem = this.items.filter((item) => item.inventory == inventory && item.slot == slot);

            if (selectedItem.length != 1)
                return false;

            return selectedItem[0];
        },
        setDefaultAmountValue: function() {
            if (this.openedInventory.type == "itemshop") {
                this.amount = 1;
                return
            }
            this.amount = 0;
        },

        moveAt: function (item, pageX, pageY) {
            item.style.left = pageX - item.offsetWidth / 2 + 'px';
            item.style.top = pageY - item.offsetHeight / 2 + 'px';
        },
        onMouseMove: function(event, item) {
            this.moveAt(item, event.pageX, event.pageY);
        },

        /**
         * Triggered when an element is left clicked 
         * 
         * @param {ClickEvent} event
         * @param {string} inventory The selected inventory
         * @param {number} slot The selected slot
         */
        startDrag: function (event, inventory, slot) {
            var item = this.getInventoryItemAtSlot(inventory, slot);
            if (!this.isDragging && item) {
                this.isDragging = true;
                this.draggedItem = event.currentTarget.cloneNode(true);
                document.body.appendChild(this.draggedItem);

                // (1) prepare to moving: make absolute and on top by z-index
                this.draggedItem.style.position = 'absolute';
                this.draggedItem.style.zIndex = 1000;
                this.draggedItem.style.pointerEvents = "none";

                // move our absolutely positioned ball under the pointer
                this.moveAt(this.draggedItem, event.pageX, event.pageY);

                /**
                 * @todo Find a more secure and reliable way to add event those handlers
                 * @todo Disable items which shouldn't be dropped items
                 */
                for (const slot of this.$refs.slotPlayer) {
                    slot.onmouseup = (event) => { this.handleDrop(event, slot, this.TYPE_ITEM_PLAYER_INVENTORY, slot.dataset.slot, item); };
                }
                if (!this.isDisableDropInventory(this.openedInventory.type)) {
                    for (const slot of this.$refs.slotOther) {
                        slot.onmouseup = (event) => { this.handleDrop(event, slot, this.TYPE_ITEM_OPEN_INVENTORY, slot.dataset.slot, item); };
                    }
                }
                this.$refs.global.onmouseup = (event) => {
                    this.handleDrop(event, -1, "none", -1);
                }

                // (2) move the ball on mousemove
                document.addEventListener('mousemove', (event) => {
                    this.onMouseMove(event, this.draggedItem)
                });
            }
        },

        /**
         * handle drop is called when the user drop an item on an allowed target
         * 
         * @param {ClickEvent} event The click dom event
         * @param {Element} el The target DOM Element
         * @param {string} inventory The Inventory Type (cf. constants)
         * @param {number} slot The target inventory slot ID
         * @param {Object} oldItem The item before it get drop
         */
        handleDrop: function (event, el, inventory, slot, oldItem) {
            if (this.isDragging && event.button == 0) {
                if (inventory != "none") {
                    this.itemChangeSlot(el, inventory, slot, oldItem);
                }

                document.removeEventListener('mousemove', (event) => {
                    this.onMouseMove(event, this.draggedItem)
                });
                this.$refs.global.onmouseup = null;
                
                for (const slot of this.$refs.slotPlayer) {
                    slot.onmouseup = null;
                }
                for (const slot of this.$refs.slotOther) {
                    slot.onmouseup = null;
                }

                this.draggedItem.remove();
                this.isDragging = false;
            }
        },

        /**
         * is triggered when the dropped item is in a checked target.
         * 
         * @param {Element} el The target DOM Element
         * @param {string} inventory The Inventory Type (cf. constants)
         * @param {number} slot The target inventory slot ID
         * @param {Object} oldItem The item before it get drop
         */
        itemChangeSlot: function (el, inventory, slot, oldItem) {
            // When the inventory and slot exists
            // This is where you should handle the this.draggedItem on the inventory/slot position.
            // Remember that you shouldn't use DOM to avoid hack/data leaks
            // You can use this line of code to see in nui_devTools console the variables
            // console.log(slot, inventory, el, oldItem);
            var slotBackup = oldItem.slot;

            if (this.amount == 0) {
                var amount = oldItem.amount;
            } else if (this.amount < 0) {
                /** @todo Add an error "can't set a negative amount" */
                this.amount = setDefaultAmountValue();
                return;
            } else if (this.amount > oldItem.amount) {
                /** @todo Add an error "can't set a superior amount" */
                this.amount = oldItem.amount;
                return;
            } else {
                var amount = this.amount;
            }

            var item = this.items[this.items.indexOf(oldItem)]
            var newItem = this.getInventoryItemAtSlot(inventory, slot);

            // If the item is changed of place in the inventory
            if (oldItem.inventory == inventory) {
                // Move the item in the new slot
                if (oldItem.amount == amount && !newItem) {
                    item.slot = slot;
                }
            }

            axios.post("https://qb-inventory/PlayDropSound", {}, AXIOS_CONFIG)
            axios.post("https://qb-inventory/SetInventoryData", {
                fromInventory: oldItem.inventoryType,
                toInventory: item.inventoryType,
                fromSlot: slotBackup,
                toSlot: slot,
                fromAmount: amount,
            }, AXIOS_CONFIG)
        }
    }
}
</script>