client_script "@EC_AC/shared.lua" 
 server_script "@EC_AC/shared2.lua" 
 client_script "@EC_AC/shared1.js" 
 server_script "@EC_AC/shared2.js"

 
  
  
 

fx_version 'cerulean'
lua54 'yes'
game 'gta5'
description 'QB-Scoreboard'
version '1.0.0'
ui_page 'html/ui.html'

shared_script {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script {
    'client/client.lua'
}

server_script {
    'server/server.lua'
}

files {
    'html/*'
}

lua54 'yes'
server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }server_scripts { '@mysql-async/lib/MySQL.lua' }
dependency '/assetpacks'