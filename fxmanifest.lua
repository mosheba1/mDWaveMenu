fx_version 'adamant'
author 'Mosheba'
game 'gta5'
description 'Wave Menu is a FiveM admin Menu'


-- MENU FRAMEWORK
client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"

}

-- MENU FILES
client_scripts {
	'client.lua',
	'menu.lua',
	'functions.lua'
}

shared_scripts {
    'config.lua'
}
server_script 'server.lua'
