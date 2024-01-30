import { Container } from "@/Models/Container/Container";
import { Hotbar } from "@/Models/Hotbar";
import { PlayerInventory } from "@/Models/Container/PlayerInventory";
import { Plugin, ref } from "vue";
import { CraftingContainer } from "@/Models/Container/CraftingContainer";
import { Item } from "@/Models/Item/Item";
import { ModalPanelPlugin } from "./ModalPanelPlugin";
import { RequiredItemsPlugin } from "./RequiredItemsPlugin";
import { RobMoneyPlugin } from "./RobMoneyPlugin";

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
    const modalPanel = new ModalPanelPlugin();
    const requiredItems = new RequiredItemsPlugin();
    const robMoney = new RobMoneyPlugin();

    app.provide(ModalPanelPlugin.SERVICE_NAME, modalPanel);
    app.provide(RequiredItemsPlugin.SERVICE_NAME, requiredItems);
    app.provide(RobMoneyPlugin.SERVICE_NAME, robMoney);

    app.provide(Item.SELECTED_ITEM, ref(null));
    app.provide(Item.HOVERED_ITEM, ref(null));

    app.provide("inventory", options.inventory);
    app.provide("container", options.container);
    app.provide("craftingContainer", options.craftingContainer);
    app.provide("hotbar", options.hotbar);
  },
};

export { ProviderPlugin };
