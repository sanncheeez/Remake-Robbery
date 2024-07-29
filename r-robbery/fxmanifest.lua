fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'sanncheez'
description 'https://discord.gg/PBwYZugT9c'
version '1.0.0'

files {
    'web/index.html',
    'web/style.css',
    'web/script.js'
}

ui_page 'web/index.html'

client_scripts {
    'src/Cmain.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'src/Smain.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}


dependencies {
    'es_extended'
}
