import { createApp } from "vue";
import App from "./App.vue";
import "./assets/tailwind.css";
import { httpClientPlugin } from "./plugins/HttpClient";
import { ProviderPlugin } from "./plugins/Provider";
import { keyPressPlugin } from "./plugins/KeyPress";
import { PlayerInventory } from "./Models/Container/PlayerInventory";
import { nuiEventPlugin } from "./plugins/NuiEvent";
import { Container } from "./Models/Container/Container";
import { Hotbar } from "./Models/Hotbar";
import { CraftingContainer } from "./Models/Container/CraftingContainer";
import { ModalPanelPlugin } from "./plugins/ModalPanelPlugin";

const inventory = new PlayerInventory();
const container = new Container();
const craftingContainer = new CraftingContainer();
const hotbar = new Hotbar();
const modalPanel = new ModalPanelPlugin();

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressPlugin)
  .use(ProviderPlugin, {
    inventory,
    container,
    craftingContainer,
    hotbar,
    modalPanel,
  })
  .use(nuiEventPlugin, { inventory, container, craftingContainer, hotbar })
  .mount("#app");
