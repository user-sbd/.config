local settings = require("settings")

-- Left items (L to R)
require("items.flash_space")

-- Right items (R to L)
require("items.calendar")
sbar.add("item", "right.spacer", {
    position = "right",
    width = settings.space.md,
    background = { drawing = false },
})
require("items.widgets")

local M = {}

M.exec = function(cmd)
    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()
    return result
end

M.split = function(str, sep)
    local parts = {}
    for part in str:gmatch("([^" .. sep .. "]+)") do
        table.insert(parts, part)
    end
    return parts
end

-- ADD THIS MAP FUNCTION
M.map = function(tbl, f)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end

return M
