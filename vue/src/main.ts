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
const { NuiEventMocker } = await import("./mock/NuiEventMocker");

if (
  process.env.NODE_ENV === "development" &&
  typeof GetParentResourceName === "undefined"
) {
  console.log("Running in browser");
  NuiEventMocker();
} else {
  console.log("Running in game");
}

const inventory = new PlayerInventory();
const container = new Container();
const craftingContainer = new CraftingContainer();
const hotbar = new Hotbar();

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressPlugin)
  .use(ProviderPlugin, { inventory, container, craftingContainer, hotbar })
  .use(nuiEventPlugin, { inventory, container, craftingContainer, hotbar })
  .mount("#app");
