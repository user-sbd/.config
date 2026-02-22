# AGENTS.md — SketchyBar Configuration

## Project Overview

Lua-based configuration for [SketchyBar](https://github.com/FelixKratz/SketchyBar), a macOS menu bar replacement. Uses the [SbarLua](https://github.com/FelixKratz/SbarLua) module for the Lua API. Native C/Swift event provider helpers exist in source and compile on launch, but are not all actively wired up to items.

The config runs on a single user's macOS machine as part of a larger dotfiles repo managed with GNU Stow. It integrates with [FlashSpace](https://github.com/wojciech-kulik/FlashSpace) for workspace management.

## Build & Reload

There is no test suite or linter. Validation is visual — reload the bar and check output.

```sh
# Reload sketchybar (picks up all Lua changes via hot reload)
sketchybar --reload

# Rebuild native helpers (C/Swift event providers + menu helper)
cd helpers && make

# Full install from scratch (brew, fonts, SbarLua)
bash helpers/install.sh
```

The helpers `makefile` compiles event providers (cpu_load, memory_load, hdd_load, network_load, media_player) and the menus helper. Compiled binaries go into `bin/` dirs (git-ignored).

`helpers/init.lua` runs `make` automatically on every sketchybar start, so helpers recompile on launch.

## Architecture & File Structure

```
sketchybarrc              # Entry point (#!/usr/bin/env lua) — loads helpers, then init
init.lua                  # Requires sbar module, wraps config in begin/end_config, starts event loop
bar.lua                   # Bar-level settings (position, height, padding, color)
default.lua               # Default item properties (fonts, colors, popup styles)
colors.lua                # Theme loader — reads SKETCHYBAR_THEME env var, maps semantic colors
colors_tokyo_night.lua    # Theme: ANSI color palette (0xAARRGGBB hex format)
colors_rose_pine.lua      # Theme: ANSI color palette
settings.lua              # Design tokens: spacing, sizing, fonts, radii
icons.lua                 # Icon sets (SF Symbols + NerdFont), selected via settings.icons
events.lua                # Custom event registration

items/
  init.lua                # Loads left items (L→R) then right items (R→L)
  flash_space.lua         # FlashSpace workspace indicators (NerdFont icons, async CLI)
  front_app.lua           # Active application name (loaded inside flash_space async callback)
  calendar.lua            # Date and time display
  widgets/
    init.lua              # Loads widget items R→L, bracket around all
    battery.lua           # Battery status
    volume.lua            # Volume indicator
    wifi.lua              # Network status

helpers/
  init.lua                # Adds SbarLua to package.cpath, runs make
  app_icons.lua           # App name → sketchybar-app-font icon mapping
  event_providers/        # C/Swift sources for system event monitors
  menus/                  # C source for menu bar helper
```

## Key Concepts

- **`sbar` global**: The SbarLua module instance, set globally in `init.lua`. All item creation and manipulation goes through it.
- **Items**: Created with `sbar.add("item", ...)`. Each item has icon, label, and background properties.
- **Events**: Custom events registered via `sbar.add("event", "event_name")`. Items subscribe with `:subscribe()`.
- **Brackets**: Group items visually with `sbar.add("bracket", ...)`.
- **Animations**: Use `sbar.animate("type", duration, callback)` — types include `"linear"`, `"elastic"`, `"tanh"`, `"sin"`, `"circ"`.
- **Async execution**: `sbar.exec(cmd, callback)` for shell commands. **Never use `io.popen`** — it blocks the event loop.
- **Config batching**: All initial setup goes between `sbar.begin_config()` / `sbar.end_config()`.
- **Theming**: Set `SKETCHYBAR_THEME` env var to switch palettes. Colors use `0xAARRGGBB` hex format.

## Code Style

### Lua Conventions

- **Indentation**: 4 spaces (not tabs).
- **Quotes**: Double quotes for strings (`"text"`).
- **Trailing commas**: Used in table literals.
- **Comments**: `--` for single-line, `--[[ ]]` for block comments. Use `-- TODO:` for planned work.
- **Semicolons**: None — Lua convention.

### Naming

- **Files**: `snake_case.lua` — e.g. `front_app.lua`, `colors_tokyo_night.lua`.
- **Variables**: `snake_case` — e.g. `volume_icon`, `current_audio_device`, `popup_width`.
- **Functions**: `snake_case` — e.g. `get_app_icon`. Prefer `snake_case` for new code.
- **Constants/config keys**: `snake_case` — e.g. `item_height`, `corner_radius`, `padding_left`.
- **Item names**: Dot-separated namespacing — e.g. `"widgets.volume1"`, `"space.1"`, `"menu.padding"`.
- **Theme files**: `colors_<theme_name>.lua` — returns a flat table of ANSI color names.

### Module Pattern

- Config/data modules return a table directly: `return { ... }`.
- Item modules typically don't return anything (side effects only), except when other modules need a reference (e.g. `front_app.lua` returns the item).
- Imports use `require()` at the top of each file, with `local` binding:

```lua
local settings = require("settings")
local colors = require("colors")
local icons = require("icons")
```

### Item Definition Pattern

Items follow a consistent structure:

```lua
local my_item = sbar.add("item", "optional.name", {
  position = "right",
  icon = { ... },
  label = { ... },
  background = { ... },
  padding_left = settings.item_padding,
  padding_right = settings.item_padding,
})

my_item:subscribe("event_name", function(env)
  -- handle event
end)
```

### Settings & Design Tokens

Use values from `settings.lua` instead of magic numbers. Available tokens:

- **Spacing**: `settings.space.{xs,sm,md,lg,xl,xxl}` (2–24px)
- **Heights**: `settings.height.{sm,md,lg}` (28–36px)
- **Radii**: `settings.radius.{xs,sm,md,lg,xl}` (8–24px)
- **Fonts**: `settings.font.{text,numbers,icons,app_icons,nerd_icons}`
- **Font sizes**: `settings.font.sizes.{text,numbers,icons,app_icons,nerd_icons}`
- **Font styles**: `settings.font.style_map["Regular"|"Medium"|"Bold"|"Black"]`
- **Item dimensions**: `settings.item_height`, `settings.item_padding`, `settings.item_corner_radius`

### Colors

Reference colors by semantic name from `colors.lua`, not raw hex:

```lua
colors.text          -- primary text
colors.red           -- errors, alerts
colors.green         -- success states
colors.yellow        -- warnings
colors.blue          -- info, directories
colors.transparent   -- fully transparent
colors.bar.bg        -- bar background (with alpha)
colors.spaces.active -- active workspace indicator
```

Use `colors.with_alpha(color, alpha)` for transparency (alpha 0.0–1.0).

### Theme Files

New themes must follow the ANSI color palette structure. Required keys:

```
black, red, green, yellow, blue, magenta, cyan, white,
bright_black, bright_red, bright_green, bright_yellow,
bright_blue, bright_purple, bright_cyan, bright_white,
transparent
```

### Error Handling

- Use `pcall` for fallible operations (see theme loading in `colors.lua`).
- Provide fallback values when operations may fail (e.g. `tonumber(x) or 0`).
- Guard `sbar.exec` callbacks against empty/nil results.

### Enabling/Disabling Items

Items and widgets are toggled by commenting/uncommenting `require()` lines in `items/init.lua` or `items/widgets/init.lua`. Keep disabled items as comments with the original require path.

## Commit Style

Conventional commits with optional scope: `type(scope): message`

- Types: `feat`, `fix`, `chore`, `refactor`, `style`, `docs`
- Scope: `sketchybar`, or omit for general changes
- Examples: `feat(sketchybar): Make a simple setup`, `chore(sketchybar): update theme colors`
