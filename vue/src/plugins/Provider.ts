import { Container } from "@/Models/Container/Container";
import { Hotbar } from "@/Models/Hotbar";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { Plugin } from "vue";

const ProviderPlugin: Plugin = {
  install(
    app,
    options: {
      inventory: PlayerInventory;
      container: Container;
      hotbar: Hotbar;
    }
  ) {
    app.provide("inventory", options.inventory);
    app.provide("container", options.container);
    app.provide("hotbar", options.hotbar);
  },
};

export { ProviderPlugin };
