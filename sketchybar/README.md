# SketchyBar Configuration

Lua-based [SketchyBar](https://github.com/FelixKratz/SketchyBar) config with [FlashSpace](https://github.com/wojciech-kulik/FlashSpace) workspace integration.

## Theming

Switch color schemes by setting the `SKETCHYBAR_THEME` environment variable:

```sh
# Fish
set -gx SKETCHYBAR_THEME rose_pine

# Bash/Zsh
export SKETCHYBAR_THEME=rose_pine
```

Then reload:

```sh
sketchybar --reload
```

Available themes: `tokyo_night` (default), `rose_pine`.

Add your own by creating `colors_<name>.lua` — see the existing theme files for the required color keys.

## Modular Structure

Items are loaded via `require()` in `items/init.lua`. Enable or disable items by commenting/uncommenting lines:

```lua
-- Left items (L to R)
require("items.flash_space")

-- Right items (R to L)
require("items.calendar")
require("items.widgets")
```

Widgets work the same way in `items/widgets/init.lua`:

```lua
require("items.widgets.battery")
require("items.widgets.wifi")
require("items.widgets.volume")
```

Design tokens (spacing, fonts, sizes, radii) live in `settings.lua`. Colors are in `colors.lua`. No magic numbers in item files.

## FlashSpace Integration

To get workspace indicators in the bar, add this command to both **"Run script on workspace change"** and **"Run script on launch"** in FlashSpace's Integration settings:

```sh
sketchybar --trigger flashspace_workspace_change WORKSPACE="$WORKSPACE" DISPLAY="$DISPLAY"
```

## Setup

```sh
# Install dependencies (brew, fonts, SbarLua)
bash helpers/install.sh

# Reload after changes
sketchybar --reload
```

For full architecture details, see [AGENTS.md](AGENTS.md).
