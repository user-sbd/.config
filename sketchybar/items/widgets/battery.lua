local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    update_freq = 2,
    icon = {
        drawing = true,
    },
    label = {
        drawing = false,
    },
    padding_right = settings.item_padding,
    padding_left = settings.item_padding,
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    sbar.exec("pmset -g batt", function(batt_info)
        local icon = "!"
        local found, _, charge = batt_info:find("(%d+)%%")
        if found then
            charge = tonumber(charge)
        end

        local color = colors.text
        local charging, _, _ = batt_info:find("AC Power")

        if charging then
            icon = icons.battery.charging
            color = colors.green
        else
            if found and charge > 80 then
                icon = icons.battery._100
            elseif found and charge > 60 then
                icon = icons.battery._75
            elseif found and charge > 40 then
                icon = icons.battery._50
            elseif found and charge > 20 then
                icon = icons.battery._25
                color = colors.yellow
            else
                icon = icons.battery._0
                color = colors.red
            end
        end

        battery:set({
            icon = {
                string = icon,
                color = color,
            },
        })
    end)
end)
