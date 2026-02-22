local settings = require("settings")
local colors = require("colors")

-- Right items (R to L)
require("items.widgets.battery")
require("items.widgets.wifi")
require("items.widgets.volume")

-- Dark background behind all widgets
sbar.add("bracket", "widgets.bracket", {
    "widgets.battery",
    "widgets.wifi.padding",
    "widgets.volume2",
}, {
    background = {
        color = colors.bar.bg,
        corner_radius = settings.space.xs,
        height = settings.bracket_height,
    },
})
