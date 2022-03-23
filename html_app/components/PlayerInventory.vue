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
                        <item-slot v-for="slot in playerInventory.slots" :key="slot"
                            :inventory="playerInventory.type" :slot="slot"
                            :item="getInventoryItemAtSlot(TYPE_ITEM_PLAYER_INVENTORY, slot)"
                            @mousedown.left.prevent="startDrag($event, TYPE_ITEM_PLAYER_INVENTORY, slot)"
                            ref="slotPlayer">
                        </item-slot>
                    </div>
                </div>
                <div class="inv-options">
                    <div class="inv-options-list">
                        <input type="number" id="item-amount" v-model="amount" class="inv-option-item" min="0" @input="event => amount = parseInt(event.target.value)"/>
                        <div class="inv-option-item" ref="useAction"><p>USE</p></div>
                        <div class="inv-option-item" ref="giveAction"><p>GIVE</p></div>
                        <div class="inv-option-item" @click.prevent="$bus.trigger('close')" id="inv-close"><p>CLOSE</p></div>
                    </div>
                </div>
                <div class="oth-inv-container">
                    <div class="other-inventory" :data-inventory="openedInventory.name">
                        <item-slot v-for="slot in openedInventory.slots" :key="slot"
                            :inventory="openedInventory.type" :slot="slot"
                            :style="[openedInventory.type == 'drop' ? {backgroundColor: 'rgba(0, 0, 0, 0.3)'} : '' ]"
                            :item="getInventoryItemAtSlot(TYPE_ITEM_OPEN_INVENTORY, slot)"
                            @mousedown.left.prevent="startDrag($event, TYPE_ITEM_OPEN_INVENTORY, slot)"
                            ref="slotOther">
                        </item-slot>
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

<script>
import axios from 'axios';
import ItemSlot from './ItemSlot.vue';
var _ = require('lodash');

const AXIOS_CONFIG = { headers: {'Content-Type': 'application/json'} };

/**
 * Component to manage every inventory (or "tab") part
 * 
 * @todo Add Language support on HTML side
*/
export default {
  components: { ItemSlot },
    props: ['inventories'],
    data() {
        return {
            id: 0,
            items: [],
            isDragging: false,
            draggedItem: null,
            playerInventory: {
                slots: 0,
                type: "player",
                name: "player",
                maxweight: 0,
            },
            openedInventory: {
                name: "",
                slots: 30,
                label: "Drop",
                type: "drop",
                maxweight: 100000,
            },
            amount: 0,
        }
    },
    mounted () {
        this.playerInventory.slots = this.inventories.slots;
        this.playerInventory.maxweight = this.inventories.maxweight;
        
        if (this.inventories.other != null && this.inventories.other != "") {
            this.openedInventory.name = this.inventories.other.name + "";
            if (this.inventories.other.label.toLowerCase().split('-')[0] == "dropped") {
                this.openedInventory.type = this.inventories.other.label.split('-')[1];
            } else {
                this.openedInventory.type = this.inventories.other.name;
            }
            this.openedInventory.slots = this.inventories.other.slots;
            this.openedInventory.type = this.openedInventory.type.split("-")[0];
            this.openedInventory.label = this.inventories.other.label;
            this.openedInventory.maxweight = this.inventories.other.maxweight;
        }

        if (this.inventories.inventory !== null) {
            for (const [slot, item] of Object.entries(this.inventories.inventory)) {
                if (item != null) {
                    this.items.push(this.convertItemFromQB(this.id++, item, this.TYPE_ITEM_PLAYER_INVENTORY, this.TYPE_ITEM_PLAYER_INVENTORY));
                }
            }
        }

        if (this.inventories.other != null && this.inventories.other != "" && this.inventories.other.inventory != null) {
            for (const [slot, item] of Object.entries(this.inventories.other.inventory)) {
                if (item != null) {
                    this.items.push(this.convertItemFromQB(this.id++, item, this.TYPE_ITEM_OPEN_INVENTORY, this.openedInventory.type));
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
            return this.INVENTORY_TYPE_DISABLE_DROP.includes(inventory);
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

                this.draggedItem.style.position = 'absolute';
                this.draggedItem.style.zIndex = 1000;
                this.draggedItem.style.pointerEvents = "none";

                this.moveAt(this.draggedItem, event.pageX, event.pageY);
                document.addEventListener('mousemove', (event) => this.onMouseMove(event, this.draggedItem));

                /**
                 * @todo Find a more secure and reliable way to add event those handlers
                 * @todo Disable items which shouldn't be dropped items
                 */
                for (const slot of this.$refs.slotPlayer) {
                    slot.$el.onmouseup = (event) => this.handleDrop(event, slot, this.TYPE_ITEM_PLAYER_INVENTORY, slot.slot, item);
                }
                if (!this.isDisableDropInventory(this.openedInventory.type)) {
                    for (const slot of this.$refs.slotOther) {
                        slot.$el.onmouseup = (event) => this.handleDrop(event, slot, this.TYPE_ITEM_OPEN_INVENTORY, slot.slot, item);
                    }
                }

                // Drop on usage buttons
                this.$refs.useAction.onmouseup = (event) => this.handleDrop(event, -1, "use", -1, item);
                this.$refs.giveAction.onmouseup = (event) => this.handleDrop(event, -1, "give", -1, item);

                // Disable the drop nowhere
                this.$refs.global.onmouseup = (event) => this.handleDrop(event, -1, "none", -1);
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
                
                // Drop on usage buttons
                this.$refs.useAction.onmouseup = null;
                this.$refs.giveAction.onmouseup = null;
                this.$refs.global.onmouseup = null;
                for (const slot of this.$refs.slotPlayer) {
                    slot.$el.onmouseup = null;
                }
                for (const slot of this.$refs.slotOther) {
                    slot.$el.onmouseup = null;
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
        itemChangeSlot: function (el, inventory, slot, oldItemSlot) {
            // When the inventory and slot exists
            // This is where you should handle the this.draggedItem on the inventory/slot position.
            // Remember that you shouldn't use DOM to avoid hack/data leaks
            // You can use this line of code to see in nui_devTools console the variables
            // console.log(el, inventory, slot, oldItemSlot);
            var newItemSlot = this.getInventoryItemAtSlot(inventory, slot);
            var backupItem = {...oldItemSlot}

            var backupItems = _.cloneDeep(this.items);

            var inventoryName = inventory;
            if (inventory != this.TYPE_ITEM_PLAYER_INVENTORY) {
                var inventoryName = this.openedInventory.name;
            }

            if (backupItem.inventory == inventory && backupItem.slot == slot) {
                return false;
            }

            if (inventory == "use") {
                axios.post("https://qb-inventory/UseItem", {
                    inventory: oldItemSlot.inventory,
                    item: this.convertItemToQB(oldItemSlot),
                }, AXIOS_CONFIG)
                this.$bus.trigger('close')
                return;
            }

            if (this.amount == 0) {
                if (this.openedInventory.type == "itemshop" || this.openedInventory.type == "crafting") {
                    /** @todo Add an error */
                    this.amount = 1;
                    return;
                }
                var amount = oldItemSlot.amount;
            } else if (this.amount < 0) {
                /** @todo Add an error "can't set a negative amount" */
                this.amount = setDefaultAmountValue();
                return;
            } else if (this.amount > oldItemSlot.amount) {
                /** @todo Add an error "can't set a superior amount" */
                this.amount = oldItemSlot.amount;
                return;
            } else {
                var amount = this.amount;
            }

            if (inventory == "give") {
                axios.post("https://qb-inventory/GiveItem", {
                    inventory: oldItemSlot.inventory,
                    item: this.convertItemToQB(oldItemSlot),
                    amount: parseInt(amount),
                }, AXIOS_CONFIG)
                return;
            }

            var indexItem = this.items.indexOf(oldItemSlot);
            var item = this.items[indexItem];

            var newItemIndex = this.items.indexOf(newItemSlot);

            // If it's an empty slot
            if (!newItemSlot) {
                item.amount -= amount;

                item = {...item};
                item.id = this.id++;
                item.inventory = inventory;
                item.inventoryType = inventoryName;
                item.amount = amount;
                item.slot = slot;

                this.items.push(item);
            // If the new slot is the same and is not unique
            } else if (oldItemSlot.name == newItemSlot.name && !oldItemSlot.unique && !newItemSlot.unique) {
                item.amount -= amount;
                this.items[newItemIndex].amount += amount;
            } else {
                if (this.isDisableDropInventory(this.items[indexItem].inventoryType)) {
                    return;
                }

                var old_slot = this.items[indexItem].slot;
                var old_inventory = this.items[indexItem].inventory;
                var old_inventoryType = this.items[indexItem].inventoryType;

                this.items[indexItem].slot = this.items[newItemIndex].slot
                this.items[indexItem].inventory = this.items[newItemIndex].inventory
                this.items[indexItem].inventoryType = this.items[newItemIndex].inventoryType
                this.items[newItemIndex].inventory = old_inventory
                this.items[newItemIndex].inventoryType = old_inventoryType
                this.items[newItemIndex].slot = old_slot
            }

            // Remove source item if not amount
            if (this.items[indexItem].amount <= 0) {
                this.items.splice(indexItem, 1);
            }

            // Check weight
            if (this.totalWeight > this.playerInventory.maxweight || this.totalWeightOther > this.openedInventory.maxweight) {
                /** @todo Send an error warning */
                Object.assign(this.items, backupItems);
                console.log(this.items);
                return
            }

            axios.post("https://qb-inventory/PlayDropSound", {}, AXIOS_CONFIG)
            axios.post("https://qb-inventory/SetInventoryData", {
                fromInventory: (backupItem.inventory == this.TYPE_ITEM_PLAYER_INVENTORY ? this.playerInventory.name : this.openedInventory.name),
                toInventory: inventoryName,
                fromSlot: backupItem.slot,
                toSlot: slot,
                fromAmount: amount,
            }, AXIOS_CONFIG)
        }
    }
}
</script>