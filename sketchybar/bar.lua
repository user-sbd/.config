local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
    sticky = "on",
    position = "top",
    height = settings.height.lg,
    margin = settings.space.sm,
    color = colors.transparent,
    padding_right = settings.space.md,
    padding_left = settings.space.md,
    y_offset = settings.space.sm,
    topmost = "off",
})
