<template>
    <div>
        <div id="qbcore-inventory">
            <div class="inventory-info">
                <div class="player-inv-info">
                    <span id="player-inv-label">Player Inventory</span><br>
                    <span id="player-inv-weight"></span>
                </div>
                <div class="other-inv-info">
                    <span id="other-inv-label"></span><br>
                    <span id="other-inv-weight"></span>
                </div>
            </div>
            <div class="inv-container">
                <div class="ply-inv-container">
                    <div class="player-inventory" data-inventory="player"></div>
                </div>
                <div class="inv-options">
                    <div class="inv-options-list">
                        <input type="number" id="item-amount" class="inv-option-item" min=0 value="0" oninput="validity.valid||(value='');"/>
                        <div class="inv-option-item" id="item-use"><p>USE</p></div>
                        <div class="inv-option-item" id="item-give"><p>GIVE</p></div>
                        <div class="inv-option-item" id="inv-close"><p>CLOSE</p></div>
                    </div>
                </div>
                <div class="oth-inv-container">
                    <div class="other-inventory" data-inventory="other">
                            <!-- auto generated -->
                    </div>
                </div>
            </div>
            <div class="ply-hotbar-inventory" data-inventory="hotbar">
                    <!-- auto generated -->
            </div>
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
        <div class="weapon-attachments-container">
            <div class="weapon-attachments-container-title">Pistol | <span style="font-size: 2vh;">9mm</span></div>
            <div class="weapon-attachments-container-description">This is a water gun yaay ...</div>
            <div class="weapon-attachments-container-details"><span style="font-weight: bold; letter-spacing: .1vh;">Serial Number</span><br> 12345678<br><br><span style="font-weight: bold; letter-spacing: .1vh;">Durability</span> <div class="weapon-attachments-container-detail-durability"><div class="weapon-attachments-container-detail-durability-total"></div></div></div>
            <img src="./attachment_images/weapon_pistol.png" class="weapon-attachments-container-image">

            <div class="weapon-attachments-title"><span style="font-weight: bold; letter-spacing: .1vh;">Attachments</span></div>
            <div class="weapon-attachments">
            </div>

            <div class="weapon-attachments-remove"><i class="fas fa-trash"></i></div>

            <div class="weapon-attachments-back"><p>RETURN</p></div>
        </div>
        <div class="combine-option-container">
            <div class="btn-combine CombineItem"><p>Combine</p></div>
            <div class="btn-combine SwitchItem"><p>Switch</p></div>
        </div>
        <div class="itemboxes-container"></div>
        <div class="itembox-container template"></div>
        <div class="requiredItem-container">
        </div>
    </div>
</template>

<script>
export default {
    props: ['inventories'],
}
</script>