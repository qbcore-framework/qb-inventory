<template>
    <div class="weapon-attachments-container" v-if="weapon != null">
        <div class="weapon-attachments-container-title">
            {{ weapon.label }} | <span style="font-size: 2vh;">{{ ammoLabel }}</span>
        </div>
        <div class="weapon-attachments-container-description">{{ weapon.description }}</div>
        <div class="weapon-attachments-container-details">
            <span style="font-weight: bold; letter-spacing: .1vh;">Serial Number</span><br>
            {{ item.info.serie }}<br>
            <br>
            <span style="font-weight: bold; letter-spacing: .1vh;">Durability {{ durability.toFixed() }}% </span>
            <div class="weapon-attachments-container-detail-durability">
                <div class="weapon-attachments-container-detail-durability-total" :style="{width: durability + '%'}"></div>
            </div>
        </div>
        <img :src="'./attachment_images/' + weapon.name + '.png'" class="weapon-attachments-container-image">

        <div class="weapon-attachments-title">
            <span style="font-weight: bold; letter-spacing: .1vh;" v-if="attachments.length > 0">Attachments</span>
            <span style="font-weight: bold; letter-spacing: .1vh;" v-else>This gun doesn't contain attachments</span>
        </div>
        
        <div class="weapon-attachments">
            <div class="weapon-attachment" v-for="(attachment, index) in attachments" :key="index">
                <div class="weapon-attachment-label">
                    <p>{{ attachment.label }}</p>
                </div> 
                <div class="weapon-attachment-img">
                    <img :src="'./images/' + weaponType + '_' + attachment.attachment + '.png'">
                </div>
            </div>
        </div>

        <div class="weapon-attachments-remove"><i class="fas fa-trash"></i></div>

        <div class="weapon-attachments-back" @click.prevent="$bus.trigger('disableAttachments')"><p>RETURN</p></div>
    </div>
</template>

<script>
import axios from 'axios';
/**
 * @todo EVERYTHING !
 */
export default {
    data() {
        return {
            weapon: null,
            item: null,
            attachments: {}
        }
    },
    mounted() {
        this.$bus.on("enableAttachments", (data) => {
            this.loadWeaponData(data.name, data.data);
        })

        this.$bus.on("disableAttachments", () => {
            this.weapon = null;
            this.item = null;
            this.attachments = {};
        })
    },
    computed: {
        ammoLabel() {
            if (this.weapon.ammotype == "AMMO_RIFLE") {
                return "7.62";
            } else if (this.weapon.ammotype == "AMMO_SHOTGUN") {
                return "12 Gauge";
            }
            return "9mm";
        },
        durability() {
            if (this.item.info.quality !== undefined) {
                return this.item.info.quality;
            }
            return 100;
        },
        weaponType() {
            return this.weapon.ammotype
                                .split("_")[1]
                                .toLowerCase();
        }
    },
    methods: {
        loadWeaponData: function(weapon, item) {
            var self = this;

            axios.post("https://qb-inventory/GetWeaponData", {
                weapon: weapon,
                ItemData: item,
            }, this.AXIOS_CONFIG)
            .then((data) => {
                data = data.data

                self.weapon = data.WeaponData;
                self.item = item;
                self.attachments = {}

                if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
                    self.attachments = data.AttachmentData;
                }

                console.log(self.item, self.weapon);
            })
        }
    }
}
</script>