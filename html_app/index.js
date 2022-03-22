import { createApp } from 'vue'
import App from './App.vue'

const app = createApp(App)

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
        else if (weaponInfo.quality > 25 && weaponInfo.quality < 50)
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
    }

    return weaponInfo
}

app.mount('#app')