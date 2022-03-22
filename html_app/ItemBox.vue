<template>
    <div class="itemboxes-container">
        <transition-group name="fade">
            <div class="itembox-container" v-for="item in itemsShown.slice().reverse()" :key="item.id">
                <div id="itembox-action">
                    <p>
                        {{ item.type }}
                    </p>
                </div>
                <div id="itembox-label">
                    <p>
                        {{ item.label }}
                    </p>
                </div>
                <div class="item-slot-img">
                    <img :src="item.image" :alt="item.name" />
                </div>
            </div>
        </transition-group>
    </div>
</template>

<style> 
    .fade-enter-active {
        transition: all .8s ease-in-out;
    }
    .fade-leave-active {
        transition: all .8s ease-in-out;
    }
    .fade-enter-from {
        transform: translateX(-20px) !important;
        opacity: 0 !important;
    }
    .fade-leave-to {
        transform: translateX(20px);
        opacity: 0;
    }
    .fade-move {
        transition: transform .8s;
    }
</style>

<script>
export default {
    data() {
        return {
            itemsShown: [],
            id: 0,
        }
    },
    mounted() {
        this.itemsShown = [];
    },
    methods: {
        AddItemBox: function(data) {
            var type = "Used"; /** @todo Add translation support */
            if (data.type == "add") {
                type = "Received"; /** @todo Add translation support */
            } else if (data.type == "remove") {
                type = "Removed"; /** @todo Add translation support */
            }

            this.itemsShown.push({
                id: this.id++,
                type: type,
                label: data.item.label ,
                image: "images/" + data.item.image ,
                name: data.item.name,
            })
            
            setTimeout(() => this.removeLatestItembox(), 3000); /** @todo add this to a JS Config */
        },
        removeLatestItembox: function() {
            this.itemsShown.shift();
        }
    }
}
</script>