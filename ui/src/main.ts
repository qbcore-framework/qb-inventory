import { createApp } from "vue";
import App from "./App.vue";
import "./assets/tailwind.css";
import { httpClientPlugin } from "./plugins/HttpClient";
import { ProviderPlugin } from "./plugins/ProviderPlugin";
import { keyPressEventHandler } from "./plugins/KeyPressEventHandler";
import { PlayerInventory } from "./Models/Container/PlayerInventory";
import { nuiEventHandler } from "./plugins/NuiEventHandler";
import { Container } from "./Models/Container/Container";
import { Hotbar } from "./Models/Hotbar";
import { CraftingContainer } from "./Models/Container/CraftingContainer";

const inventory = new PlayerInventory();
const container = new Container();
const craftingContainer = new CraftingContainer();
const hotbar = new Hotbar();

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressEventHandler)
  .use(ProviderPlugin, {
    inventory,
    container,
    craftingContainer,
    hotbar,
  })
  .use(nuiEventHandler, { inventory, container, craftingContainer, hotbar })
  .mount("#app");
