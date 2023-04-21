import { Inventory } from "@/Models/Inventory";
import { Plugin } from "vue";

const keyPressPlugin: Plugin = {
  install(app, options: { inventory: Inventory }) {
    const inventory = options.inventory;

    // Track key presses for tab, esc
    window.addEventListener("keydown", (e) => {
      if (e.repeat) return;

      if (e.key === "Tab") {
        e.preventDefault();
        inventory.Close();
      } else if (e.key === "Escape") {
        inventory.Close();
      }
    });
  }
}

export { keyPressPlugin };