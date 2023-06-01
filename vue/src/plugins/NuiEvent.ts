import { Container } from "@/Models/Container/Container";
import { Hotbar } from "@/Models/Hotbar";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { ParseInventory } from "@/Parser/ItemParser";
import { Plugin } from "vue";

const nuiEventPlugin: Plugin = {
  install(
    app,
    options: {
      inventory: PlayerInventory;
      container: Container;
      hotbar: Hotbar;
    }
  ) {
    const inventory = options.inventory;
    const container = options.container;
    const hotbar = options.hotbar;
    window.addEventListener("message", (event) => {
      const data = event.data;
      const action = data.action;

      if (action === "open") {
        console.log("open", data);
        if (data.other) {
          container.UpdateContents(
            data.other.name,
            ParseInventory(data.other.inventory, data.other.slots),
            data.other.maxweight,
            data.other.maxammo,
            data.other.Ammo
          );
        } else {
          container.UpdateContents(
            "0",
            new Array(10),
            1000,
            {
              pistol: 0,
              shotgun: 0,
              rifle: 0,
              smg: 0,
            },
            []
          );
        }

        inventory.UpdateContents(
          ParseInventory(data.inventory, data.slots),
          data.maxweight,
          data.maxammo,
          data.Ammo
        );
        inventory.Open();
      } else if (action === "close") {
        console.log("close", data);
        window.dispatchEvent(new CustomEvent("inventory:close"));
      } else if (action === "update") {
        console.log("update", data);
        inventory.UpdateContents(
          ParseInventory(data.inventory, data.slots),
          data.maxweight,
          data.maxammo,
          data.Ammo
        );
        // Update the inventory
      } else if (action === "itemBox") {
        console.log("itemBox", data);

        // Something to do with the item box
      } else if (action === "requiredItem") {
        console.log("requiredItem", data);

        // Something to do with a required item
      } else if (action === "toggleHotbar") {
        console.log("toggleHotbar", data);
        hotbar.Toggle(data.items, data.open);
        // Toggle the hotbar visibility
      } else if (action === "RobMoney") {
        console.log("RobMoney", data);

        // Add option to take money from player
      }
    });
  },
};

export { nuiEventPlugin };
