local colors = {}
local config_dir = os.getenv("CONFIG_DIR")
local theme_file = config_dir .. "/helpers/active_theme.txt"

-- Create the directory once when the script loads if not available yet
os.execute("mkdir -p " .. config_dir .. "/helpers")

-- 1. Define Common Colors
colors.white = 0xffffffff
colors.transparent = 0x00000000
colors.red = 0xffff4444
colors.orange = 0xffffa500
colors.charging = 0xffffd700

-- 2. Define Your Schemes
local schemes = {
	gruvbox = {
		bar_color = 0x70282828,
		accent_color = 0xffd79921,
		secondary_accent = 0xfffabd2f,
		disabled_color = 0xffd3d3d3,
		background = 0xfa1e1e2e,
		popup_background = 0xff282828,
	},
	teal = {
		bar_color = 0x40001f30,
		accent_color = 0xfa001f30,
		secondary_accent = 0xff397d89,
		disabled_color = 0xff397d89,
		background = 0xff2cf9ed,
		popup_background = 0xff2cf9ed,
	},
	blacknwhite = {
		bar_color = 0x40000000,
		accent_color = 0xffffffff,
		secondary_accent = 0xffa9cce3,
		disabled_color = 0xffb0b0b0,
		background = 0xfa101314,
		popup_background = 0xff101314,
	},
	purple = {
		bar_color = 0x70140c42,
		accent_color = 0xffeb46f9,
		secondary_accent = 0xffa569bd,
		disabled_color = 0xffb8a1d9,
		background = 0xfa140c42,
		popup_background = 0xff140c42,
	},
	red = {
		bar_color = 0x7023090e,
		accent_color = 0xffff2453,
		secondary_accent = 0xffc0392b,
		disabled_color = 0xffe1a2a6,
		background = 0xfa23090e,
		popup_background = 0xff23090e,
	},
	blue = {
		bar_color = 0x70021254,
		accent_color = 0xff15bdf9,
		secondary_accent = 0xff5dade2,
		disabled_color = 0xffaac5e0,
		background = 0xfa021254,
		popup_background = 0xff021254,
	},
	green = {
		bar_color = 0x70003315,
		accent_color = 0xff1dfca1,
		secondary_accent = 0xff52be80,
		disabled_color = 0xffa1e0c0,
		background = 0xfa003315,
		popup_background = 0xff003315,
	},
	orange = {
		bar_color = 0x70381c02,
		accent_color = 0xfff97716,
		secondary_accent = 0xffeb984e,
		disabled_color = 0xffe0bfa1,
		background = 0xfa381c02,
		popup_background = 0xff381c02,
	},
	yellow = {
		bar_color = 0x702d2b02,
		accent_color = 0xfff7fc17,
		secondary_accent = 0xfff4d03f,
		disabled_color = 0xffe9dea1,
		background = 0xfa2d2b02,
		popup_background = 0xff2d2b02,
	},
	liquid_glass = {
		bar_color = 0x00000000,
		accent_color = 0xffffffff,
		secondary_accent = 0xffd6eaf8,
		disabled_color = 0xff777777,
		background = 0x20ffffff,
		popup_background = 0xee1a1d1e,
	},
}

-- 3. Select Active Scheme
local active_name
local first_available = next(schemes)

local f = io.open(theme_file, "r")
if f then
	local content = f:read("*all"):gsub("%s+", "")
	if schemes[content] then
		active_name = content
	end
	f:close()
end

active_name = active_name or first_available
local active_scheme_data = schemes[active_name]

-- 4. Merge (Now simple and direct)
for k, v in pairs(active_scheme_data) do
	colors[k] = v
end

-- 5. Export Metadata
colors.active_scheme_name = active_name
colors.all_schemes = schemes

return colors
