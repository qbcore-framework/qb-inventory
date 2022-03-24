<template>
    <div class="ply-iteminfo-container">
        <div class="ply-iteminfo">
            <div class="iteminfo-content" v-if="item != null && item.info != ''">
                <div class="item-info-title">{{ title }}</div>
                <div class="item-info-line"></div>

                <div class="item-info-description" v-if="item.name == 'id_card'">
                    <p><strong>{{ i18n.itemInfo.csn }}: </strong><span>{{ item.info.citizenid }}</span></p>
                    <p><strong>{{ i18n.itemInfo.first_name }}: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.last_name }}: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.birth_date }}: </strong><span>{{ item.info.birthdate }}</span></p>
                    <p><strong>{{ i18n.itemInfo.gender }}: </strong><span>{{ item.info.gender == 1 ? "Woman" : "Man" }}</span></p>
                    <p><strong>{{ i18n.itemInfo.nationality }}: </strong><span>{{ item.info.nationality }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'driver_license'">
                    <p><strong>{{ i18n.itemInfo.first_name }}: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.last_name }}: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.birth_date }}: </strong><span>{{ item.info.birthdate }}</span></p>
                    <p><strong>{{ i18n.itemInfo.licenses }}: </strong><span>{{ item.info.type }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'weaponlicense'">
                    <p><strong>{{ i18n.itemInfo.first_name }}: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.last_name }}: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.birth_date }}: </strong><span>{{ item.info.birthdate }}"</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'lawyerpass'">
                    <p><strong>{{ i18n.itemInfo.lawyer_pass_id }} </strong><span>{{ item.info.id }}</span></p>
                    <p><strong>{{ i18n.itemInfo.first_name }}: </strong><span>{{ item.info.firstname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.last_name }}: </strong><span>{{ item.info.lastname }}</span></p>
                    <p><strong>{{ i18n.itemInfo.csn }}: </strong><span>{{ item.info.citizenid }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'harness'">
                    <p>{{ item.info.uses }} {{ i18n.itemInfo.usage_left }}.</p>
                </div>
                <div class="item-info-description" v-else-if="item.type == 'weapon' && item.info.attachments != null">
                    <p><strong>{{ i18n.itemInfo.serial_number }}: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>{{ i18n.itemInfo.munition }}: </strong><span>{{ item.info.ammo }}"</span></p>
                    <p><strong>Attachments: </strong><span>{{ attachmentString }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.type == 'weapon'">
                    <p><strong>{{ i18n.itemInfo.serial_number }}: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>{{ i18n.itemInfo.munition }}: </strong><span>{{ item.info.ammo }}</span></p>
                    <p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'casing'">
                    <p><strong>{{ i18n.itemInfo.evidence_material }}: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>{{ i18n.itemInfo.type_number }}: </strong><span>{{ item.info.ammotype }}</span></p>
                    <p><strong>{{ i18n.itemInfo.caliber }}: </strong><span>{{ item.info.ammolabel }}</span></p>
                    <p><strong>{{ i18n.itemInfo.serial_number }}: </strong><span>{{ item.info.serie }}</span></p>
                    <p><strong>{{ i18n.itemInfo.crime_scene }}: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'blood'">
                    <p><strong>{{ i18n.itemInfo.evidence_material }}: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>Blood type: </strong><span>{{ item.info.bloodtype }}</span></p>
                    <p><strong>{{ i18n.itemInfo.dna_code }}: </strong><span>{{ item.info.dnalabel }}</span></p>
                    <p><strong>{{ i18n.itemInfo.crime_scene }}: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'fingerprint'">
                    <p><strong>{{ i18n.itemInfo.evidence_material }}: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>{{ i18n.itemInfo.fingerprint }}: </strong><span>{{ item.info.fingerprint }}</span></p>
                    <p><strong>{{ i18n.itemInfo.crime_scene }}: </strong><span>{{ item.info.street }}</span></p>
                    <br /><p>{{ item.description }}</p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'filled_evidence_bag' && item.info.type == 'dna'">
                    <p><strong>{{ i18n.itemInfo.evidence_material }}: </strong><span>{{ item.info.label }}</span></p>
                    <p><strong>{{ i18n.itemInfo.dna_code }}: </strong><span>{{ item.info.dnalabel }}</span></p>
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
                    <p><strong>{{ i18n.itemInfo.amount_of_cash }}: </strong><span>${{ item.info.cash }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'markedbills'">
                    <p><strong>{{ i18n.itemInfo.worth }}: </strong><span>${{ item.info.worth }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'visa' || item.name == 'mastercard'">
                    <p><strong>{{ i18n.itemInfo.card_holder }}: </strong><span>{{ item.info.name }}</span></p>
                    <p><strong>{{ i18n.itemInfo.citizen_id }}: </strong><span>{{ item.info.citizenid }}</span></p>
                    <p><strong>{{ i18n.itemInfo.card_number }}: </strong><span>{{ cardNumber }}</span></p>
                </div>
                <div class="item-info-description" v-else-if="item.name == 'labkey'">
                    <p>{{ i18n.itemInfo.lab }}: {{ item.info.lab }}</p>
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
