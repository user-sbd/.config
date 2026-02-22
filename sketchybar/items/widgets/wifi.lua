local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local wifi = sbar.add("item", "widgets.wifi.padding", {
    position = "right",
    padding_left = settings.item_padding,
    padding_right = settings.item_padding,
    label = { drawing = false },
    icon = { drawing = true },
})

wifi:subscribe({ "wifi_change", "system_woke" }, function(env)
    sbar.exec("ipconfig getifaddr en0", function(ip)
        local connected = not (ip == "")
        wifi:set({
            icon = {
                string = connected and icons.wifi.connected or icons.wifi.disconnected,
                color = connected and colors.white or colors.red,
            },
        })
    end)
end)
