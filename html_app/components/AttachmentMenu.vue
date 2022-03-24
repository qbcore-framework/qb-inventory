<template>
    <div class="weapon-attachments-container" v-if="weapon != null" ref="global">
        <div class="weapon-attachments-container-title">
            {{ weapon.label }} | <span style="font-size: 2vh;">{{ ammoLabel }}</span>
        </div>
        <div class="weapon-attachments-container-description">{{ weapon.description }}</div>
        <div class="weapon-attachments-container-details">
            <span style="font-weight: bold; letter-spacing: .1vh;">{{ i18n.attachments.serial_number }}</span><br>
            {{ item.info.serie }}<br>
            <br>
            <span style="font-weight: bold; letter-spacing: .1vh;">{{ i18n.attachments.durability }} {{ durability.toFixed() }}% </span>
            <div class="weapon-attachments-container-detail-durability">
                <div class="weapon-attachments-container-detail-durability-total" :style="{width: durability + '%'}"></div>
            </div>
        </div>
        <img :src="'./attachment_images/' + weapon.name + '.png'" class="weapon-attachments-container-image">

        <div class="weapon-attachments-title">
            <span style="font-weight: bold; letter-spacing: .1vh;" v-if="attachments.length > 0">{{ i18n.attachments.attachments }}</span>
            <span style="font-weight: bold; letter-spacing: .1vh;" v-else>{{ i18n.attachments.no_attachment }}</span>
        </div>
        
        <div class="weapon-attachments">
            <div class="weapon-attachment" 
                v-for="(attachment, index) in attachments"
                :key="index"
                @mousedown.left.prevent="startDrag($event, attachment)">
                <div class="weapon-attachment-label">
                    <p>{{ attachment.label }}</p>
                </div> 
                <div class="weapon-attachment-img">
                    <img :src="'./images/' + weaponType + '_' + attachment.attachment + '.png'">
                </div>
            </div>
        </div>

        <div class="weapon-attachments-remove" ref="removeAction"><i class="fas fa-trash"></i></div>

        <div class="weapon-attachments-back" @click.prevent="$bus.trigger('disableAttachments')"><p>{{ i18n.attachments.return_btn }}</p></div>
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
            attachments: {},
            isDragging: false,
            draggedItem: null,
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
    unmounted () {
        if (this.isDragging)
            this.draggedItem.remove();
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
            })
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
        startDrag: function (event, attachment) {
            if (!this.isDragging) {
                this.isDragging = true;
                this.draggedItem = event.currentTarget.cloneNode(true);
                document.body.appendChild(this.draggedItem);

                this.draggedItem.style.position = 'absolute';
                this.draggedItem.style.zIndex = 1000;
                this.draggedItem.style.pointerEvents = "none";

                this.moveAt(this.draggedItem, event.pageX, event.pageY);
                document.addEventListener('mousemove', (event) => this.onMouseMove(event, this.draggedItem));

                this.$refs.removeAction.onmouseup = (event) => this.handleDrop(event, attachment);

                // Disable the drop nowhere
                this.$refs.global.onmouseup = (event) => this.handleDrop(event, null);
                this.$refs.global.style.cursor = "not-allowed";
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
        handleDrop: function (event, attachment) {
            if (this.isDragging && event.button == 0) {
                if (attachment) {
                    this.itemChangeSlot(attachment);
                }

                document.removeEventListener('mousemove', (event) => {
                    this.onMouseMove(event, this.draggedItem, attachment)
                });
                
                // Reset drop on usage buttons
                this.$refs.removeAction.onmouseup = null;
                this.$refs.global.onmouseup = null;
                this.$refs.global.style.cursor = "default";

                this.draggedItem.remove();
                this.isDragging = false;
            }
        },

        /**
         * is triggered when the dropped item is in a delete box.
         * 
         */
        itemChangeSlot: function (attachment) {
            console.log(attachment, this.weapon);
            axios.post("https://qb-inventory/RemoveAttachment",{
                    AttachmentData: attachment,
                    WeaponData: this.item,
                }, this.AXIOS_CONFIG)
                .then((data) => {
                    data = data.data;
                    console.log(data);
                    
                    if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
                        this.attachments = data.AttachmentData;
                    } else {
                        this.attachments = {}
                    }
                })
        }
    }
}
</script>