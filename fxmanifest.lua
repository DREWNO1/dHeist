fx_version 'cerulean'
game 'gta5'

author 'Drewno <kontakt@drewno.me>'
description 'Procedural heist system'
version '0.0.1-ALPHA'

shared_script {
    'config.lua',
}

client_script {
    'client/main.lua',
    'heist_phone/main.lua',
    'heist_phone/ped.lua'
}

server_script {
    'server/main.lua'
}
