import { Container } from "@/Models/Container/Container";
import { Hotbar } from "@/Models/Hotbar";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { ParseCraftingInventory, ParseInventory } from "@/Parser/ItemParser";
import { Plugin } from "vue";
import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { CreateContainerItem } from "@/Parser/ItemParser";
import { ParseHotbarItems } from "@/Parser/HotbarParser";

const nuiEventPlugin: Plugin = {
  install(
    app,
    options: {
      inventory: PlayerInventory;
      container: Container;
      craftingContainer: CraftingContainer;
      hotbar: Hotbar;
    },
  ) {
    const inventory = options.inventory;
    const container = options.container;
    const craftingContainer = options.craftingContainer;
    const hotbar = options.hotbar;
    window.addEventListener("message", (event) => {
      const data = event.data;
      const action = data.action;

      if (action === "open") {
        console.log("open", data);
        if (data.other) {
          if (data.other.name === "crafting") {
            craftingContainer.UpdateContents(
              ParseCraftingInventory(data.other.inventory, data.other.slots),
              data.other.maxweight,
            );
            craftingContainer.Open();
          } else {
            container.UpdateContents(
              data.other.name,
              ParseInventory(data.other.inventory, data.other.slots),
              data.other.maxweight,
              data.other.maxammo,
              data.other.Ammo,
            );
            container.Open();
          }
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
            [],
          );
          container.Open();
        }

        inventory.UpdateContents(
          ParseInventory(data.inventory, data.slots),
          data.maxweight,
          data.maxammo,
          data.Ammo,
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
          data.Ammo,
        );
      } else if (action === "itemBox") {
        console.log("itemBox", data);

        window.dispatchEvent(
          new CustomEvent("inventory:item-box", {
            detail: {
              item: CreateContainerItem(data.item),
              type: data.type,
            },
          }),
        );
        // Something to do with the item box
      } else if (action === "requiredItem") {
        console.log("requiredItem", data);

        // Something to do with a required item
      } else if (action === "toggleHotbar") {
        console.log("toggleHotbar", data);
        hotbar.Toggle(ParseHotbarItems(data.items), data.open);
        // Toggle the hotbar visibility
      } else if (action === "RobMoney") {
        console.log("RobMoney", data);

        // Add option to take money from player
      }
    });
  },
};

export { nuiEventPlugin };
