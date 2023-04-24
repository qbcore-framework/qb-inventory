import { Container } from "@/Models/Container";
import { Inventory } from "@/Models/Inventory";
import { Plugin } from "vue";

const InventoryPlugin: Plugin = {
  // Track key presses for tab, esc
  install(app, options: { inventory: Inventory, container: Container }) {
    app.provide("inventory", options.inventory);
    app.provide("container", options.container);
  }
}

export { InventoryPlugin };