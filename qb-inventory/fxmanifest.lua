fx_version 'cerulean'
game 'gta5'

description 'QB-Inventory'
version '1.0.0'

server_scripts {
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/main.css',
	'html/js/app.js',
	'html/images/*.png',
	'html/images/*.jpg',
	'html/ammo_images/*.png',
	'html/attachment_images/*.png',
	'html/*.ttf',
}