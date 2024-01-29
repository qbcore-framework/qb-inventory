fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'QB-Inventory'
version '1.2.4'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

client_script 'client/main.lua'

ui_page {
    'ui/dist/index.html'
}

files {
    'ui/dist/index.html',
    'ui/dist/favicon.ico',
    'ui/dist/js/*.js',
    'ui/dist/js/*.js.map',
    'ui/dist/css/*.css',
    'ui/dist/img/*.png',

}

dependency 'qb-weapons'
