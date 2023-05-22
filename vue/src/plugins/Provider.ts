import { Container } from "@/Models/Container";
import { Hotbar } from "@/Models/Hotbar";
import { Inventory } from "@/Models/Inventory";
import { Plugin } from "vue";

const ProviderPlugin: Plugin = {
  install(
    app,
    options: { inventory: Inventory; container: Container; hotbar: Hotbar }
  ) {
    app.provide("inventory", options.inventory);
    app.provide("container", options.container);
    app.provide("hotbar", options.hotbar);
  },
};

export { ProviderPlugin };
