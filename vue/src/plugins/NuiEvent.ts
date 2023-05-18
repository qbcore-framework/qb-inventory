import { Container } from "@/Models/Container";
import { Hotbar } from "@/Models/Hotbar";
import { Inventory } from "@/Models/Inventory";
import { Plugin } from "vue";

const nuiEventPlugin: Plugin = {
  install(app, options: { inventory: Inventory, container: Container, hotbar: Hotbar }) {
    const inventory = options.inventory;
    const container = options.container;
    const hotbar = options.hotbar;
    window.addEventListener('message', (event) => {
      const data = event.data;
      const action = data.action;      

      if (action === "open") {
        console.log("open", data);
        // Check if user is opening a container as well
        if (data.other) {
          container.Open(data.other);
        }
        inventory.Open(data);
      } else if (action === "close") {
        console.log("close", data);
        window.dispatchEvent(new CustomEvent("inventory:close"));
      } else if (action === "update") {
        console.log("update", data);
        
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
  }
}

export { nuiEventPlugin };