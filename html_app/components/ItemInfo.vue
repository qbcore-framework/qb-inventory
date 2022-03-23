<template>
    <div class="ply-iteminfo-container">
        <div class="ply-iteminfo">
            <div class="iteminfo-content" v-if="item != null && item.info != ''">
                <div class="item-info-title">{{ title }}</div>
                <div class="item-info-line"></div>

                <div class="item-info-description" v-if="item.name == 'id_card'">
                    <p><strong>CSN: </strong><span>{{ item.info.citizenid }}</span></p>
                    <p><strong>First Name: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>Last Name: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>Birth Date: </strong><span>this.{{ item.info.birthdate }}</span></p>
                    <p><strong>Gender: </strong><span>{{ item.info.gender == 1 ? "Woman" : "Man" }}</span></p>
                    <p><strong>Nationality: </strong><span>{{ item.info.nationality }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'driver_license'">
                    <p><strong>First Name: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>Last Name: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>Birth Date: </strong><span>{{ item.info.birthdate }}</span></p>
                    <p><strong>Licenses: </strong><span>{{ item.info.type }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'weaponlicense'">
                    <p><strong>First Name: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>Last Name: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>Birth Date: </strong><span>{{ item.info.birthdate }}"</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'lawyerpass'">
                    <p><strong>Pass-ID: </strong><span>{{ item.info.id }}</span></p>
                    <p><strong>First Name: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>Last Name: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>CSN: </strong><span>{{ item.info.citizenid }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'harness'">
                    <p>{{ item.info.uses }} uses left.</p>
                </div>
                <div class="item-info-description" v-else-if="item.type == 'weapon' && item.info.attachments != null">
                    <p><strong>Serial Number: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>Munition: </strong><span>{{ item.info.ammo }}"</span></p>
                    <p><strong>Attachments: </strong><span>{{ attachmentString }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.type == 'weapon'">
                    <p><strong>Serial Number: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>Munition: </strong><span>{{ item.info.ammo }}</span></p>
                    <p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'casing'">
                    <p><strong>Evidence material: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>Type number: </strong><span>{{ item.info.ammotype }}</span></p>
                    <p><strong>Caliber: </strong><span>{{ item.info.ammolabel }}</span></p>
                    <p><strong>Serial Number: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>Crime scene: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'blood'">
                    <p><strong>Evidence material: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>Blood type: </strong><span>{{ item.info.bloodtype }}</span></p>
                    <p><strong>DNA Code: </strong><span>{{ item.info.dnalabel }}</span></p>
                    <p><strong>Crime scene: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'fingerprint'">
                    <p><strong>Evidence material: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>Fingerprint: </strong><span>{{ item.info.fingerprint }}</span></p>
                    <p><strong>Crime Scene: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'dna'">
                    <p><strong>Evidence material: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>DNA Code: </strong><span>{{ item.info.dnalabel }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'stickynote'">
                    <p>{{ item.label }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.info && item.info.costs">
                    <p>{{ item.info.costs }}</p>
                    <p>{{ item.info.label }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'moneybag'">
                    <p><strong>Amount of cash: </strong><span>${{ item.info.cash }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'markedbills'">
                    <p><strong>Worth: </strong><span>${{ item.info.worth }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'visa' || item.name == 'mastercard'">
                    <p><strong>Card Holder: </strong><span>{{ item.info.name }}</span></p>
                    <p><strong>Citizen ID: </strong><span>{{ item.info.citizenid }}</span></p>
                    <p><strong>Card Number: </strong><span>{{ cardNumber }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'labkey'">
                    <p>Lab: {{ item.info.lab }}</p>
                </div>
                <div class="item-info-description" v-else>
                    {{ description }}
                </div>
            </div>
            <div class="iteminfo-content" v-else>
                <div class="item-info-title">{{ title }}</div>
                <div class="item-info-line"></div>
                <div class="item-info-description">
                    {{ description }}
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            item: null,
            title: "",
            description: "",
            attachmentString: "",
        }
    },
    mounted() {
        this.$bus.on('setInfo', (incomingItem) => {
            this.item = incomingItem;
            this.title = incomingItem.label;
            this.description = incomingItem.description;

            if (this.item.type == "weapon") {
                if (!this.item.info.ammo)
                    this.item.info.ammo = 0;
                
                if (this.item.info.attachments != null) {
                    this.item.info.attachments.forEach((attachment, i) => {
                        if (i == this.item.info.attachments.length - 1) {
                            this.attachmentString += attachment.label;
                        } else {
                            this.attachmentString += attachment.label + ", ";
                        }
                    });
                }
            }
        });

        this.$bus.on('resetInfo', () => {
            this.item = null;
            this.title = "";
            this.description = "";
            this.attachmentString = "";
        });
    },
}
</script>
