# NUI Side of QB-Inventory

## Introduction

The project was made with JQuery, a large file (around 2 000+ lines) with a lot of possibility of failures, hack, etc...

So I decided to re-build the JavaScript with Vue.JS, but keeping the whole HTML/CSS part so the end-user doesn't see any difference)

## Work On

The folder `html_app` will be build under the name `html` (specified in `webpack.config.js` or `index.js`).

__Worktree__:
 - `ammo_images/`           Contains every ammos images (*undex jpg or png extenstion*)
 - `attachment_images/`     Contains every attachments images (*undex jpg or png extenstion*)
 - `images/`                Contains every others images (*undex jpg or png extenstion*)
 - `components/`            Contains every VueJS 3 components (*under .vue*)
    - `ItemBox.vue`         Contains the ItemBox component (display information if the item is used, removed or added)
    - `PlayerHotbar.vue`    Describe the PlayerHotbar component (display the player's hotbar)
    - `PlayerInventory.vue` Describe the PlayerInventory component (display the player inventory with actions around items)
 - `index.html`             Default Structure of the page and import default fonts and icons
 - `index.css`              Global stylesheet of the project
 - `index.js`               Instanciate the VueJS3 App. And contains every global functions (IsWeaponBlocked, getWeaponInfo)
 - `App.vue`                Manage the whole Vue App (refer to `components/` folder)

### Installation process

You should have install Node.JS with NPM.
In the resource directory, you can open a terminal and execute:

```bash
npm i
```

### Developpment process

You just need to comment the `webpack_config` in the `fxmanifest.lua`.

You just have to type in the same terminal:
```bash
npm run watch
```

(*PLEASE: you should restart the script in-game so the javascript get refreshed!*)

### Let lambda user install script

When you commit, you should think to uncomment the `webpack_config` in the `fxmanifest.lua`.

## Resources

Usefull links that gaves me workarounds:
 - https://forum.cfx.re/t/html-5-drag-and-drog/2134864/2 ➡️ NUI unusable drags events...
 - https://javascript.info/mouse-drag-and-drop 🎈 The solution is here