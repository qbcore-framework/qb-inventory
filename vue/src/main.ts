import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import { httpClientPlugin } from './plugins/HttpClient'
import { InventoryPlugin } from './plugins/Inventory'
import { keyPressPlugin } from './plugins/KeyPress'
import { Inventory } from './Models/Inventory'
import { nuiEventPlugin } from './plugins/NuiEvent'
// TODO: Remove this
import invJson from "../test/inventory-open-event.json"

const inventory = new Inventory();

inventory.Open(invJson as any);

createApp(App)
  .use(httpClientPlugin)
  .use(InventoryPlugin, { inventory })
  .use(keyPressPlugin, { inventory })
  .use(nuiEventPlugin, { inventory })
  .mount('#app')
