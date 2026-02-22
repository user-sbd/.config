local colors = require("colors")
local settings = require("settings")

local front_app = sbar.add("item", "front_app", {
    position = "left",
    icon = {
        drawing = false,
    },
    label = {
        color = colors.white,
        font = {
            style = settings.font.style_map["Bold"],
        },
        padding_left = settings.space.md,
        padding_right = settings.space.md,
    },
    background = {
        color = colors.transparent,
    },
    updates = true,
})

-- Bracket for dark background
sbar.add("bracket", "front_app.bracket", { front_app.name }, {
    background = {
        color = colors.bar.bg,
        corner_radius = settings.space.xs,
        height = settings.bracket_height,
    },
})

front_app:subscribe("front_app_switched", function(env)
    front_app:set({
        label = { string = env.INFO },
    })
end)

-- Set initial value on load/reload
sbar.exec("osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'", function(result)
    front_app:set({
        label = { string = result:gsub("\n", "") },
    })
end)
