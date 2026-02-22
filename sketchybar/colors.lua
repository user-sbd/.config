-- Dynamic theme loader with ANSI color mapping
-- Set SKETCHYBAR_THEME environment variable to switch themes
-- Valid values: "tokyo_night" (default), "moon", "rose_pine"

local theme = os.getenv("SKETCHYBAR_THEME") or "tokyo_night"
local theme_file = "colors_" .. theme

local success, base_colors = pcall(require, theme_file)

if not success then
  print("Warning: Failed to load theme '" .. theme .. "', falling back to colors_tokyo_night")
  base_colors = require("colors_tokyo_night")
end

-- Create semantic color mappings from ANSI colors
local colors = {}

-- Copy all base colors (excluding with_alpha function)
for k, v in pairs(base_colors) do
  if k ~= "with_alpha" then
    colors[k] = v
  end
end

-- Add with_alpha function once
colors.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end
  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

-- Map semantic names to ANSI colors
colors.base = base_colors.black
colors.surface = base_colors.bright_black
colors.overlay = base_colors.bright_black
colors.muted = base_colors.bright_black
colors.subtle = base_colors.bright_black
colors.text = base_colors.bright_white
colors.love = base_colors.red
colors.gold = base_colors.yellow
colors.rose = base_colors.magenta
colors.pine = base_colors.cyan
colors.foam = base_colors.blue
colors.iris = base_colors.magenta
colors.high = base_colors.bright_black
colors.med = base_colors.bright_black
colors.low = base_colors.black

-- UI specific colors
colors.bg1 = base_colors.bright_black
colors.bg2 = base_colors.bright_black
colors.grey = base_colors.bright_black
colors.quicksilver = base_colors.bright_black


colors.background = base_colors.black              -- text background, shadow
colors.red = base_colors.red                       -- errors, diff delete
colors.green = base_colors.green                   -- success, diff add
colors.yellow = base_colors.yellow                 -- warnings, emphasis
colors.blue = base_colors.blue                     -- directories, keywords
colors.magenta = base_colors.magenta               -- strings, syntax highlight
colors.cyan = base_colors.cyan                     -- info, hints
colors.white = base_colors.white                   -- default foreground
colors.dim_foreground = base_colors.bright_black   -- dim text, comments
colors.bright_red = base_colors.bright_red         -- strong errors
colors.bright_green = base_colors.bright_green     -- bright success
colors.bright_yellow = base_colors.bright_yellow   -- bright warnings, highlights
colors.bright_magenta = base_colors.bright_magenta -- bold strings
colors.bright_cyan = base_colors.bright_cyan       -- links, hints
colors.bright_text = base_colors.bright_white      -- bright text

-- Structured colors
colors.bar = {
  bg = colors.with_alpha(base_colors.black, 0.8),
  border = base_colors.bright_black,
}
colors.popup = {
  bg = colors.with_alpha(base_colors.bright_black, 0.9),
  border = base_colors.bright_black
}
colors.spaces = {
  active = base_colors.bright_black,
  inactive = colors.with_alpha(base_colors.black, 0.0)
}

return colors
