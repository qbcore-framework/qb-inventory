fx_version 'cerulean'
game 'gta5'

description 'QB-Inventory'
version '1.0.0'

shared_scripts {
	'config.lua',
	'@qb-weapons/config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}
client_script 'client/main.lua'

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/index.css',
	'html/main.css',
	'html/app.js',
	'html/images/*.png',
	'html/images/*.jpg',
	'html/ammo_images/*.png',
	'html/attachment_images/*.png',
	'html/*.ttf'
}

dependencies {
	'qb-weapons',
	'yarn',
	'webpack'
}

-- Comment this when you developp, and in the cmd in this directory: npm run watch
-- webpack_config 'webpack.config.js'


lua54 'yes'
