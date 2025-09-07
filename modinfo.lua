name = "Renewable Fireflies"
description = "Makes fireflies respawn at their original location after being picked up, provided the area is clear."
author = "rafaelpadovezi"
version = "1.0.0"

forumthread = ""
api_version = 10
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = { "Regrowth" }

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
    {
        name = "respawn_time",
        label = "Respawn Time (days)",
        options = {
            {description = "5 Day", data = 5},
            {description = "10 Days", data = 10},
            {description = "20 Days", data = 20},
            {description = "30 Days", data = 30},
        },
        default = 20,
    },
    {
        name = "check_radius",
        label = "Clear Area Radius",
        options = {
            {description = "Small (1)", data = 1},
            {description = "Medium (2)", data = 2},
            {description = "Large (3)", data = 3},
        },
        default = 2,
    },
    {
        name = "debug_mode",
        label = "Debug Mode",
        options = {
            {description = "Off", data = false},
            {description = "On", data = true},
        },
        default = false,
    },
}