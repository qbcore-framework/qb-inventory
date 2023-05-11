import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import { httpClientPlugin } from './plugins/HttpClient'
import { InventoryPlugin } from './plugins/Inventory'
import { keyPressPlugin } from './plugins/KeyPress'
import { Inventory } from './Models/Inventory'
import { nuiEventPlugin } from './plugins/NuiEvent'
import { Container } from './Models/Container'

const inventory = new Inventory();
const container = new Container();

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressPlugin)
  .use(InventoryPlugin, { inventory, container })
  .use(nuiEventPlugin, { inventory, container })
  .mount('#app')
