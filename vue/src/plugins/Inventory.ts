import { Inventory } from "@/Models/Inventory";
import { Plugin } from "vue";

const InventoryPlugin: Plugin = {
  // Track key presses for tab, esc
  install(app, options: { inventory: Inventory }) {
    app.provide("inventory", options.inventory);
  }
}

export { InventoryPlugin };