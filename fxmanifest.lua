fx_version "cerulean"

author "m_gnus - Modular"
description ""
version "1.0.0"

lua54 "yes"

game "gta5"

-- ui_page "http://localhost:5173"
ui_page "html/index.html"

shared_script {
    "config.lua",
    "locales/*.lua"
}
client_scripts {
    "@PolyZone/client.lua",
    "@PolyZone/BoxZone.lua",
    "frameworks/**/client.lua",
    "client/functions.lua",
    "client/events.lua",
    "client/nuicallbacks.lua",
    "client/commands.lua",
    "client/main.lua"
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "setup/*.lua",
    "frameworks/**/server.lua",
    "server/functions.lua",
    "server/events.lua",
    "server/main.lua"
}

files { "html/index.html", "html/**/*" }

dependencies {
    "PolyZone",
    "oxmysql"
}

escrow_ignore {
    "config.lua",
    "frameworks/**/*.lua",
    "setup/*.lua",
    "locales/*.lua",
    -- "**/*.lua"
}

dependency '/assetpacks'