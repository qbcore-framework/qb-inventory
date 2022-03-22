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

            <div class="inv-container">
                <div class="ply-inv-container">
                    <div class="player-inventory" data-inventory="player">
                        <div v-for="slot in playerInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :item="item = getInventoryItemAtSlot(TYPE_ITEM_PLAYER_INVENTORY, slot)"
                            :class="{ 'item-slot': true, 'draggable': !(!item) }"
                            :ref="TYPE_ITEM_PLAYER_INVENTORY+'-'+slot"
                            @mousedown.prevent="startDrag"
                            @dragstart.prevent>
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
                        <input type="number" id="item-amount" v-model="amount" class="inv-option-item" min="0" oninput="validity.valid||(value='');"/>
                        <div class="inv-option-item" id="item-use"><p>USE</p></div>
                        <div class="inv-option-item" id="item-give"><p>GIVE</p></div>
                        <div class="inv-option-item" id="inv-close"><p>CLOSE</p></div>
                    </div>
                </div>
                <div class="oth-inv-container">
                    <div class="other-inventory" :data-inventory="openedInventory.name">
                        <div :class="{ 'item-slot': true, 'draggable': item }"
                            v-for="slot in openedInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :style="[openedInventory.type == 'drop' ? {backgroundColor: 'rgba(0, 0, 0, 0.3)'} : '' ]"
                            :item="item = getInventoryItemAtSlot(TYPE_ITEM_OPEN_INVENTORY, slot)"
                            @mousedown.prevent="startDrag"
                            @dragstart.prevent>
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
                            <div class="item-slot-amount" v-if="item && !item.price">
                                <p>{{ item.amount }} ({{ ((item.weight * item.amount) / 1000).toFixed(1) }})</p>
                            </div>
                            <div class="item-slot-amount" v-else-if="item.price">
                                <p>{{ '$' }}{{ item.price }} ({{ (item.weight / 1000).toFixed(1) }}kg)</p>
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

<script>
/**
 * Component to manage every inventory (or "tab") part
 * 
 * @todo Add Language support on HTML side
*/
const INVENTORY_TYPE_DISABLE_DROP = ['itemshop', 'crafting']

export default {
    props: ['inventories'],
    data() {
        return {
            id: 0,
            items: [],
            isDragging: false,
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
            this.inventories.inventory.forEach((item) => {
                if (item != null) {
                    /** @todo Add the common function to share with others component */
                    this.items.push({
                        id: this.id++,
                        name: item.name,
                        label: item.label,
                        type: item.name.split("_")[0],
                        inventory: this.TYPE_ITEM_PLAYER_INVENTORY,
                        amount: item.amount,
                        weight: item.weight,
                        slot: item.slot,
                        image: "images/" + item.image,
                        isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
                        weaponInfo: this.getWeaponInfo(item)
                    })
                }
            });
        }

        if (this.inventories.other != null && this.inventories.other != "" && this.inventories.other.inventory != null) {
            this.inventories.other.inventory.forEach((item) => {
                if (item != null) {
                    this.items.push({
                        id: this.id++,
                        name: item.name,
                        label: item.label,
                        type: item.name.split("_")[0],
                        inventory: this.TYPE_ITEM_OPEN_INVENTORY,
                        amount: item.amount,
                        weight: item.weight,
                        price: item.price,
                        slot: item.slot,
                        image: "images/" + item.image,
                        isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
                        weaponInfo: this.getWeaponInfo(item)
                    })
                }
            })
        }

        // var self = this
        // this.$nextTick(function () {
        //     $(self.$el).find(".item-slot.draggable").draggable({
        //         helper: "clone",
        //         appendTo: "body",
        //         scroll: true,
        //         revertDuration: 0,
        //         revert: "invalid",
        //         cancel: ".item-nodrag",
        //         start: function(event, ui) {
        //         }
        //     });
        // })
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

        startDrag: function (event) {
            if (!this.isDragging) {
                var item = event.currentTarget.cloneNode(true);
                document.body.appendChild(item);

                // (1) prepare to moving: make absolute and on top by z-index
                item.style.position = 'absolute';
                item.style.zIndex = 1000;

                // centers the ball at (pageX, pageY) coordinates
                function moveAt(pageX, pageY) {
                    item.style.left = pageX - item.offsetWidth / 2 + 'px';
                    item.style.top = pageY - item.offsetHeight / 2 + 'px';
                }

                // move our absolutely positioned ball under the pointer
                moveAt(event.pageX, event.pageY);

                function onMouseMove(event) {
                    moveAt(event.pageX, event.pageY);
                }

                var self = this

                // (2) move the ball on mousemove
                document.addEventListener('mousemove', onMouseMove);

                // (3) drop the ball, remove unneeded handlers
                item.onmouseup = function() {
                    document.removeEventListener('mousemove', onMouseMove);
                    item.onmouseup = null;
                    item.remove();
                    self.isDragging = false;
                };
            }
        },

        base: function () {
            // ??? I dont't understand :[
            if (requiredItemOpen) {
                $(".requiredItem-container").hide();
                requiredItemOpen = false;
            }

            if (data.other != null) {
                var name = data.other.name.toString();
                if (
                    name != null &&
                    (name.split("-")[0] == "itemshop" || name == "crafting")
                ) {
                    $("#other-inv-label").html(data.other.label);
                } else {
                    $("#other-inv-label").html(data.other.label);
                    $("#other-inv-weight").html(
                        "⚖️: " +
                        (totalWeightOther / 1000).toFixed(2) +
                        " / " +
                        (data.other.maxweight / 1000).toFixed(2)
                    );
                }
                otherMaxWeight = data.other.maxweight;
                otherLabel = data.other.label;
            } else {
                $("#other-inv-label").html(Inventory.droplabel);
                $("#other-inv-weight").html(
                    "⚖️: " +
                    (totalWeightOther / 1000).toFixed(2) +
                    " / " +
                    (Inventory.dropmaxweight / 1000).toFixed(2)
                );
                otherMaxWeight = Inventory.dropmaxweight;
                otherLabel = Inventory.droplabel;
            }

            $.each(data.maxammo, function(index, ammotype) {
                $("#" + index + "_ammo")
                    .find(".ammo-box-amount")
                    .css({ height: "0%" });
            });

            if (data.Ammo !== null) {
                $.each(data.Ammo, function(i, amount) {
                    var Handler = i.split("_");
                    var Type = Handler[1].toLowerCase();
                    if (amount > data.maxammo[Type]) {
                        amount = data.maxammo[Type];
                    }
                    var Percentage = (amount / data.maxammo[Type]) * 100;

                    $("#" + Type + "_ammo")
                        .find(".ammo-box-amount")
                        .css({ height: Percentage + "%" });
                    $("#" + Type + "_ammo")
                        .find("span")
                        .html(amount + "x");
                });
            }

            handleDragDrop();
        }
    }
}
</script>