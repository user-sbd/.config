local settings = require("settings")
local colors = require("colors")

local time = sbar.add("item", "calendar.time", {
    position = "right",
    update_freq = 30,
    icon = {
        drawing = false,
    },
    label = {
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
        },
        string = "",
        color = colors.white,
    },
    padding_left = settings.space.md,
    padding_right = settings.space.md,
    background = {
        color = colors.transparent,
    },
})

local date = sbar.add("item", "calendar.date", {
    position = "right",
    update_freq = 30,
    icon = {
        drawing = false,
    },
    label = {
        color = colors.white,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
        },
    },
    padding_left = settings.space.md,
    padding_right = settings.space.md,
    background = {
        color = colors.transparent,
    },
})

-- Bracket around time and date
sbar.add("bracket", "calendar.bracket", { time.name, date.name }, {
    background = {
        color = colors.bar.bg,
        corner_radius = settings.space.xs,
        height = settings.bracket_height,
    },
})

-- Subscribe to update the time and date
date:subscribe({ "forced", "routine", "system_woke" }, function(env)
    date:set({ label = os.date("%a %b %d") })
end)

time:subscribe({ "forced", "routine", "system_woke" }, function(env)
    time:set({ label = os.date("%H:%M") })
end)


