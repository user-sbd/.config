local M = {}

--- Send command to the shared toggle terminal
--- @param cmd string The full command line to send (without final \r usually)
--- @param label? string Nice name for echo line
function M.send(cmd, label)
  if not _G.term_buf or not vim.api.nvim_buf_is_valid(_G.term_buf) then
    vim.notify("Toggle terminal buffer not found", vim.log.levels.WARN)
    return
  end

  local channel = vim.b[_G.term_buf].terminal_job_id   -- or vim.bo[_G.term_buf].channel in some cases
  if not channel or channel == 0 then
    vim.notify("No job/channel in toggle terminal", vim.log.levels.ERROR)
    return
  end

  -- Bring terminal up first
  _G.toggle_term()

  vim.defer_fn(function()
    local display = label or "Running…"
    local full_cmd = table.concat({
      "echo '────── " .. display .. " ──────'",
      cmd,
      "echo '────── Done ──────' || echo '────── Failed ──────'",
      ""   -- empty line
    }, " && ")

    -- Add carriage return so it executes
    vim.api.nvim_chan_send(channel, full_cmd .. "\r")
  end, 60)  -- tiny delay — increase to 120-150 if commands sometimes miss
end

return M
