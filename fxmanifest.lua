fx_version 'cerulean'
games { 'gta5' }

author 'Code lab'
description 'cl-smallresources'
version '1.0.0'
lua54 "yes"

shared_scripts {	
	"config.lua",
	'@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    '@ox_lib/init.lua',
}

server_script 'server/*.lua'
client_script 'client/*.lua'