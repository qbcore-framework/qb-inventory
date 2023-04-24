import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import { httpClientPlugin } from './plugins/HttpClient'
import { InventoryPlugin } from './plugins/Inventory'
import { keyPressPlugin } from './plugins/KeyPress'
import { Inventory } from './Models/Inventory'
import { nuiEventPlugin } from './plugins/NuiEvent'
import { Container } from './Models/Container'
// TODO: Remove this
import invJson from "../test/inventory-open-event.json"

const inventory = new Inventory();
const container = new Container();

inventory.Open(invJson as any);

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressPlugin)
  .use(InventoryPlugin, { inventory, container })
  .use(nuiEventPlugin, { inventory, container })
  .mount('#app')
