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
                    <span id="other-inv-weight">
                        ⚖️: {{ (totalWeightOther / 1000).toFixed(2) }} / {{ (openedInventory.maxweight / 1000).toFixed(2) }}
                    </span>
                </div>
            </div>

            <div class="inv-container">
                <div class="ply-inv-container">
                    <div class="player-inventory" data-inventory="player">
                        <div class="item-slot"
                            v-for="slot in playerInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :item="item = getInventoryItemAtSlot(TYPE_ITEM_PLAYER_INVENTORY, slot)">
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
                        <input type="number" id="item-amount" class="inv-option-item" min="0" value="0" oninput="validity.valid||(value='');"/>
                        <div class="inv-option-item" id="item-use"><p>USE</p></div>
                        <div class="inv-option-item" id="item-give"><p>GIVE</p></div>
                        <div class="inv-option-item" id="inv-close"><p>CLOSE</p></div>
                    </div>
                </div>
                <div class="oth-inv-container">
                    <div class="other-inventory" :data-inventory="openedInventory.name">
                        <div class="item-slot"
                            v-for="slot in openedInventory.slots" 
                            :data-slot="slot" :key="slot"
                            :style="[openedInventory.type == 'drop' ? {backgroundColor: 'rgba(0, 0, 0, 0.3)'} : '' ]"
                            :item="item = getInventoryItemAtSlot(TYPE_ITEM_OPEN_INVENTORY, slot)">
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
export default {
    props: ['inventories'],
    data() {
        return {
            items: [],
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
            TYPE_ITEM_PLAYER_INVENTORY: "player",
            TYPE_ITEM_OPEN_INVENTORY: "other"
        }
    },
    mounted () {
        this.playerInventory.slots = this.inventories.slots;
        this.playerInventory.maxweight = this.inventories.maxweight;
        
        if (this.inventories.other != null && this.inventories.other != "") {
            this.openedInventory.name = this.inventories.other.name;
            this.openedInventory.slots = this.inventories.other.slots;
            this.openedInventory.type = this.inventories.other.name.split('_')[0];
            this.openedInventory.label = this.inventories.other.label;
            this.openedInventory.maxweight = this.inventories.other.maxweight;
        }

        if (this.inventories.inventory !== null) {
            this.inventories.inventory.forEach((item) => {
                /** @todo Add the common function to share with others component */
                this.items.push({
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
            });
        }

        if (this.inventories.other != null && this.inventories.other != "" && this.inventories.other.inventory != null) {
            this.inventories.other.inventory.forEach((item) => {
                this.items.push({
                    name: item.name,
                    label: item.label,
                    type: item.name.split("_")[0],
                    inventory: this.TYPE_ITEM_OPEN_INVENTORY,
                    amount: item.amount,
                    weight: item.weight,
                    slot: item.slot,
                    image: "images/" + item.image,
                    isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
                    weaponInfo: this.getWeaponInfo(item)
                })
            })
        }
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
        getInventoryItemAtSlot: function(inventory, slot) {
            var selectedItem = this.items.filter((item) => item.inventory == inventory && item.slot == slot);

            if (selectedItem.length != 1)
                return false;

            return selectedItem[0];
        },
        base: function () {
            totalWeight = 0;
            totalWeightOther = 0;

            // ??? I dont't understand :[
            if (requiredItemOpen) {
                $(".requiredItem-container").hide();
                requiredItemOpen = false;
            }


            if (
                data.other != null &&
                data.other != "" &&
                data.other.inventory != null
            ) {
                $.each(data.other.inventory, function(i, item) {
                    if (item != null) {
                        totalWeightOther += item.weight * item.amount;
                        var ItemLabel =
                            '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                        if (item.name.split("_")[0] == "weapon") {
                            if (!Inventory.IsWeaponBlocked(item.name)) {
                                ItemLabel =
                                    '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' +
                                    item.label +
                                    "</p></div>";
                            }
                        }
                        $(".other-inventory")
                            .find("[data-slot=" + item.slot + "]")
                            .addClass("item-drag");
                        if (item.price != null) {
                            $(".other-inventory")
                                .find("[data-slot=" + item.slot + "]")
                                .html(
                                    '<div class="item-slot-img"><img src="images/' +
                                    item.image +
                                    '" alt="' +
                                    item.name +
                                    '" /></div><div class="item-slot-amount"><p>(' +
                                    item.amount +
                                    ") $" +
                                    item.price +
                                    "</p></div>" +
                                    ItemLabel
                                );
                        } else {
                            $(".other-inventory")
                                .find("[data-slot=" + item.slot + "]")
                                .html(
                                    '<div class="item-slot-img"><img src="images/' +
                                    item.image +
                                    '" alt="' +
                                    item.name +
                                    '" /></div><div class="item-slot-amount"><p>' +
                                    item.amount +
                                    " (" +
                                    ((item.weight * item.amount) / 1000).toFixed(1) +
                                    ")</p></div>" +
                                    ItemLabel
                                );
                        }
                        $(".other-inventory")
                            .find("[data-slot=" + item.slot + "]")
                            .data("item", item);
                        Inventory.QualityCheck(item, false, true);
                    }
                });
            }

            $("#player-inv-weight").html(
                "⚖️: " +
                (totalWeight / 1000).toFixed(2) +
                " / " +
                (data.maxweight / 1000).toFixed(2)
            );
            playerMaxWeight = data.maxweight;
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