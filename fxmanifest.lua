fx_version 'cerulean'
author 'Pandateam'
description 'Military Pack'
version '1.0'
game 'gta5'

lua54 'on'

ui_page {
    'html/index.html'
}

client_scripts {
    'client.lua',
    'chat/client.lua'
}

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    'server.lua',
    'chat/server.lua'
}

files {
	'html/index.html'
}