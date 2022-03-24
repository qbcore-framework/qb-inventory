import { createApp } from 'vue'
import App from './App.vue'
import $bus from './events.js'
import axios from 'axios'

const app = createApp(App)

var i18n = {};

app.config.globalProperties.$bus = $bus;

axios.post("https://qb-inventory/RetrieveTranslations", {}, { headers: {'Content-Type': 'application/json'} })
    .then((data) => {
        app.config.globalProperties.i18n = data.data
    })

app.config.globalProperties.TYPE_ITEM_PLAYER_INVENTORY = "player";
app.config.globalProperties.INVENTORY_TYPE_DISABLE_DROP = ['itemshop', 'crafting'];
app.config.globalProperties.TYPE_ITEM_OPEN_INVENTORY = "other";
app.config.globalProperties.AXIOS_CONFIG = { headers: {'Content-Type': 'application/json'} };

app.config.globalProperties.IsWeaponBlocked = function(WeaponName) {
    var DurabilityBlockedWeapons = [
        "weapon_unarmed",
    ];

    var retval = false;
    DurabilityBlockedWeapons.forEach(element => {
        if (element == WeaponName)
            retval = true;
    });
    return retval;
}

app.config.globalProperties.getWeaponInfo = function(item) {
    var weaponInfo = null;

    if (!this.IsWeaponBlocked(item.name) && item.name.split("_")[0] == "weapon") {
        weaponInfo = {
            quality: item.info.quality,
        }

        if (weaponInfo.quality == undefined)
            weaponInfo.quality = 100;

        // Set weapon status from the quality
        weaponInfo.color = "rgb(39, 174, 96)";
        if (weaponInfo.quality < 25)
            weaponInfo.color = "rgb(192, 57, 43)";
        else if (weaponInfo.quality >= 25 && weaponInfo.quality < 50)
            weaponInfo.color = "rgb(230, 126, 34)";
        else if (weaponInfo.quality >= 50)
            weaponInfo.color = "rgb(39, 174, 96)";
        
        // Set the weaponInfo Label to the Quality
        if (weaponInfo.quality !== undefined)
            weaponInfo.label = weaponInfo.quality.toFixed();
        else
            weaponInfo.label = weaponInfo.quality;

        if (weaponInfo.quality == 0) {
            weaponInfo.label = "BROKEN"; /** @todo: need translation support */
        }
    } else if (item.info.uses != undefined && item.info.uses != null) {
        weaponInfo = {
            quality: item.info.uses
        }
        // Set weapon status from the quality
        weaponInfo.color = "rgb(39, 174, 96)";
        if (item.info.uses == 1)
            weaponInfo.color = "rgb(192, 57, 43)";
        else if (item.info.uses == 2)
            weaponInfo.color = "rgb(230, 126, 34)";
        else
            weaponInfo.color = "rgb(39, 174, 96)";
        
        // Set the weaponInfo Label to the Quality
        if (weaponInfo.quality !== undefined)
            weaponInfo.label = weaponInfo.quality.toFixed();
        else
            weaponInfo.label = weaponInfo.quality;
    }

    return weaponInfo
}

app.config.globalProperties.convertItemToQB = function(item, slot) {
    return {
        name: item.name,
        label: item.label,
        amount: item.amount,
        type: item.type,
        description: item.description,
        image: item.image,
        weight: item.weight,
        price: item.price,
        info: item.info,
        useable: item.useable,
        combinable: item.combinable,
        unique: item.unique,
        slot: parseInt(slot ? slot : item.slot),
    }
}

app.config.globalProperties.convertItemFromQB = function(id, item, inventory, inventoryType) {
    return {
        id: id,
        name: item.name,
        label: item.label,
        type: item.name.split("_")[0],
        inventory: inventory,
        inventoryType: inventoryType,
        amount: item.amount,
        weight: item.weight,
        slot: item.slot,
        image: "images/" + item.image,
        price: item.price,
        isWeapon: item.name.split("_")[0] == "weapon" && !this.IsWeaponBlocked(item.name),
        weaponInfo: this.getWeaponInfo(item),
        description: item.description,
        useable: item.useable,
        unique: item.unique,
        combinable: item.combinable,
        info: item.info,
    }
}

app.mount('#app')