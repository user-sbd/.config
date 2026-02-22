local icons = require("icons")
local colors = require("colors")
local helpers = require("helpers")

local spaces = {}

local function create_space(space_index)
    -- Aerospace space creation
    local space = sbar.add("space", "space." .. space_index, {
        icon = {
            string = space_index,
            padding_left = (tonumber(space_index) == 1 and 12 or 8) + 4,
            padding_right = 8,
            color = colors.grey,
            highlight_color = colors.white,
        },
        label = {
            drawing = false,
            padding_right = 0,
            width = 0,
        },
        padding_left = 0,
        padding_right = 0,
        background = {
            color = colors.bg1,
            border_color = colors.bg2,
            height = 30,
            corner_radius = 9,
        },
        -- Aerospace command to focus workspace
        click_script = "aerospace workspace " .. space_index,
    })

    return space
end

-- Function to get Aerospace workspaces
local function get_aerospace_workspaces()
    local handle = io.popen("aerospace list-workspaces --all")
    local result = handle:read("*a")
    handle:close()

    local workspaces = {}
    for workspace in result:gmatch("%S+") do
        table.insert(workspaces, workspace)
    end
    return workspaces
end

-- Function to get focused workspace
local function get_focused_workspace()
    local handle = io.popen("aerospace list-workspaces --focused")
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+", "")
end

-- Function to check if workspace has windows
local function workspace_has_windows(workspace)
    local handle = io.popen("aerospace list-windows --workspace " .. workspace .. " 2>/dev/null | wc -l")
    local count = handle:read("*a")
    handle:close()
    return tonumber(count) > 1 -- Subtract header line
end

-- Main update function
local function update_spaces()
    local workspaces = get_aerospace_workspaces()
    local focused = get_focused_workspace()

    for _, workspace in ipairs(workspaces) do
        local space_item = sbar.query("space." .. workspace)
        if space_item then
            -- Update icon appearance
            local icon_color = colors.grey
            local bg_color = colors.bg1

            if workspace == focused then
                icon_color = colors.white
                bg_color = colors.bg2
            elseif workspace_has_windows(workspace) then
                icon_color = colors.white
            end

            sbar.update("space." .. workspace, {
                icon = { color = icon_color },
                background = { color = bg_color }
            })
        end
    end
end

-- Create spaces for all Aerospace workspaces
local function setup_spaces()
    local workspaces = get_aerospace_workspaces()

    for _, workspace in ipairs(workspaces) do
        spaces[workspace] = create_space(workspace)
    end

    -- Convert spaces table to array for bracket
    local space_items = {}
    for _, space in pairs(spaces) do
        table.insert(space_items, space)
    end

    -- Add bracket
    sbar.add("bracket", "spaces_bracket", space_items, {
        background = { color = colors.bg1 }
    })

    -- Subscribe to Aerospace events (using Sketchybar's event system)
    sbar.add("event", "aerospace_workspace_change")
    sbar.add("event", "aerospace_window_change")

    -- Subscribe to events
    sbar.subscribe("aerospace_workspace_change", update_spaces)
    sbar.subscribe("aerospace_window_change", update_spaces)

    -- Initial update
    update_spaces()

    return spaces
end

return setup_spaces()
