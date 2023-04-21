import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import { httpClientPlugin } from './plugins/HttpClient'
import { InventoryPlugin } from './plugins/Inventory'
import { keyPressPlugin } from './plugins/KeyPress'
import { Inventory } from './Models/Inventory'

const inventory = new Inventory();

createApp(App)
  .use(httpClientPlugin)
  .use(InventoryPlugin, { inventory })
  .use(keyPressPlugin, { inventory })
  .mount('#app')
