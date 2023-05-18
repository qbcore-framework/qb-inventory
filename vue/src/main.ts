import { createApp } from 'vue'
import App from './App.vue'
import './assets/tailwind.css'
import { httpClientPlugin } from './plugins/HttpClient'
import { ProviderPlugin } from './plugins/Provider'
import { keyPressPlugin } from './plugins/KeyPress'
import { Inventory } from './Models/Inventory'
import { nuiEventPlugin } from './plugins/NuiEvent'
import { Container } from './Models/Container'
import { Hotbar } from './Models/Hotbar'

const inventory = new Inventory();
const container = new Container();
const hotbar = new Hotbar();

createApp(App)
  .use(httpClientPlugin)
  .use(keyPressPlugin)
  .use(ProviderPlugin, { inventory, container, hotbar })
  .use(nuiEventPlugin, { inventory, container, hotbar })
  .mount('#app')
