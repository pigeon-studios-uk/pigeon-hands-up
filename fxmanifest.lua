fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'pigeon-hands-up'
author 'Pigeon Studios'
description 'Hands up on a key, and kneel with your hands behind your head, with weapons locked away and a state bag for police resources.'
version '0.1.0'
repository 'https://github.com/pigeon-studios-uk/pigeon-hands-up'

-- Pigeon Studios version registry entry, read by server/version_check.lua.
pigeon_slug 'pigeon-hands-up'

client_scripts {
    'configuration/config.lua',
    'locales/*.lua',
    'client/main.lua',
}

server_scripts {
    'server/version_check.lua',
}
