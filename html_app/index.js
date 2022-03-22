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

app.mount('#app')