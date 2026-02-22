local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local volume_icon = sbar.add("item", "widgets.volume2", {
    position = "right",
    padding_right = settings.item_padding,
    padding_left = settings.item_padding,
    icon = {
        drawing = true,
        width = 18,
        align = "center",
    },
})

local volume_percent = sbar.add("item", "widgets.volume1", {
    position = "right",
    icon = { drawing = false },
    label = { drawing = false },
})

volume_percent:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)
    local icon = icons.volume._0
    local color = colors.white
    if volume > 60 then
        icon = icons.volume._100
    elseif volume > 30 then
        icon = icons.volume._66
    elseif volume > 10 then
        icon = icons.volume._33
    elseif volume > 0 then
        icon = icons.volume._10
    elseif volume == 0 then
        icon = icons.volume._0
        color = colors.grey
    end

    volume_icon:set({ icon = { string = icon, color = color } })
end)
