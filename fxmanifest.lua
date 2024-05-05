fx_version 'cerulean'
lua54 'yes'

game 'gta5'

shared_scripts {
    'config.lua',
    -- '@ox_lib/init.lua',
}

client_scripts{
    'client/*.lua',
}

server_scripts{
    'server/*.lua',
}

dependency{
    'oxmysql',
}
