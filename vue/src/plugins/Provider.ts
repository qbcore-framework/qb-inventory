import { Container } from "@/Models/Container/Container";
import { Hotbar } from "@/Models/Hotbar";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { Plugin, ref } from "vue";
import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { Item } from "@/Models/Item/Item";

const ProviderPlugin: Plugin = {
  install(
    app,
    options: {
      inventory: PlayerInventory;
      container: Container;
      craftingContainer: CraftingContainer;
      hotbar: Hotbar;
    },
  ) {
    app.provide("inventory", options.inventory);
    app.provide("container", options.container);
    app.provide("craftingContainer", options.craftingContainer);
    app.provide("hotbar", options.hotbar);
    app.provide(Item.SELECTED_ITEM, ref(null));
    app.provide(Item.HOVERED_ITEM, ref(null));
  },
};

export { ProviderPlugin };
