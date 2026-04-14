vim.g.compile_mode = {
  default_command = {
    python    = "python3 %",
    python3   = "python3 %",
    c   = "gcc -std=c17 -Wall -Wextra -o %:t:r % && ./%:t:r",
    cpp = "g++ -std=c++23 -Wall -Wextra -o %:t:r % && ./%:t:r",
    java      = "javac % && java %:r",
    go        = "go run %",
    rust      = "cargo run",
    typst     = "typst compile %",
    sh        = "bash %",
    bash      = "bash %",
  },

  bang_expansion     = true,
  ask_about_save     = true,
  ask_to_interrupt   = true,
  buffer_name        = "Compilation",
  time_format        = "%a %b %e %H:%M:%S",
  hidden_output      = {},
}

local term_buf    = nil
local term_win    = nil
local term_job_id = nil

_G.run_in_terminal = function(raw_cmd)
  if not raw_cmd or raw_cmd:match("^%s*$") then
    vim.notify("No command provided", vim.log.levels.WARN)
    return
  end

  local expanded = vim.fn.expandcmd(raw_cmd)

  -- Remove redundant ./ or .// that appear before filename/root
  -- This fixes ././file  → ./file    and  .//full/path → /full/path
  local cleaned_cmd = expanded:gsub("%.%/?%./", "./"):gsub("^%./+", "")

  -- Also collapse any multiple slashes that might remain (rare)
  cleaned_cmd = cleaned_cmd:gsub("//+", "/")

  local needs_recreate = true
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    if term_job_id and vim.fn.jobwait({ term_job_id }, 0)[1] == -1 then
      needs_recreate = false
    end
  end

  if needs_recreate then
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      pcall(vim.api.nvim_buf_delete, term_buf, { force = true })
    end
    term_buf = nil
    term_win = nil
    term_job_id = nil

    vim.cmd("belowright 10split | terminal")
    term_buf = vim.api.nvim_get_current_buf()
    term_win = vim.api.nvim_get_current_win()
    term_job_id = vim.b.terminal_job_id

    vim.bo[term_buf].bufhidden = "hide"
    vim.bo[term_buf].filetype = "toggleterm"

    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = term_buf,
      once = true,
      callback = function()
        term_buf = nil
        term_win = nil
        term_job_id = nil
      end,
    })
  else
    if not term_win or not vim.api.nvim_win_is_valid(term_win) then
      vim.cmd("belowright 10split")
      term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(term_win, term_buf)
    else
      vim.api.nvim_set_current_win(term_win)
    end
  end

  local cwd
  if vim.bo.filetype == "oil" then
    local ok, oil = pcall(require, "oil")
    if ok then cwd = oil.get_current_dir(0) end
  end
  if not cwd or cwd == "" then cwd = vim.fn.expand("%:p:h") end
  if not cwd or cwd == "" then cwd = vim.fn.getcwd() end

  if cwd and cwd ~= "" and vim.fn.isdirectory(cwd) == 1 then
    local ok, err = pcall(vim.fn.chdir, cwd)
    if not ok then
      vim.notify("chdir failed to: " .. cwd .. "\n" .. tostring(err), vim.log.levels.WARN)
    end
  end

  if term_job_id and vim.fn.jobwait({ term_job_id }, 0)[1] == -1 then
    if cwd and cwd ~= "" then
      vim.fn.chansend(term_job_id, "cd " .. vim.fn.fnameescape(cwd) .. " 2>/dev/null\n")
    end
  end

  -- Use the cleaned version
  vim.fn.chansend(term_job_id, cleaned_cmd .. "\n")
  vim.cmd("startinsert")
end

_G.toggle_term = function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end
  local cwd
  if vim.bo.filetype == "oil" then
    local ok, oil = pcall(require, "oil")
    if ok then cwd = oil.get_current_dir(0) end
  end
  if not cwd or cwd == "" then
    cwd = vim.fn.expand("%:p:h")
  end
  if not cwd or cwd == "" then
    cwd = vim.fn.getcwd()
  end
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf)
      or not term_job_id or vim.fn.jobwait({ term_job_id }, 0)[1] ~= -1 then
    vim.cmd("belowright 10split | terminal")
    term_buf    = vim.api.nvim_get_current_buf()
    term_win    = vim.api.nvim_get_current_win()
    term_job_id = vim.b.terminal_job_id
    vim.bo[term_buf].bufhidden = "hide"
    vim.bo[term_buf].filetype  = "toggleterm"
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = term_buf,
      once   = true,
      callback = function()
        term_buf    = nil
        term_win    = nil
        term_job_id = nil
      end,
    })
  else
    vim.cmd("belowright 10split")
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_win, term_buf)
  end
  vim.fn.chdir(cwd)
  if term_job_id and vim.fn.jobwait({ term_job_id }, 0)[1] == -1 then
    vim.fn.chansend(term_job_id, "cd " .. vim.fn.fnameescape(cwd) .. "\n")
  end
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local defaults = vim.g.compile_mode.default_command or {}
  local default_cmd = defaults[ft] or defaults[vim.fn.fnamemodify(vim.fn.expand("%"), ":e")] or ""
  local cmd = vim.fn.input("Compile: ", default_cmd)
  if cmd == "" then return end
  vim.b.run_command = cmd
  _G.run_in_terminal(cmd)
end, { desc = "Run / Compile in persistent terminal" })
vim.keymap.set("n", "<leader>m", function()
  local cmd = vim.b.run_command
  if cmd and cmd ~= "" then
    _G.run_in_terminal(cmd)
  else
    vim.notify("No previous run command for this buffer", vim.log.levels.WARN)
  end
end, { desc = "Re-run last compile/run command" })

vim.keymap.set({"n","t"}, "<C-s>", _G.toggle_term, { desc = "Toggle persistent terminal" })

-- vim.keymap.set("n", "<C-q>", ":copen<CR>", { silent = true })
-- for i = 1, 9 do
-- 	vim.keymap.set('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
-- end
-- vim.keymap.set("n", "<leader>a",
-- 	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
-- 	{ desc = "Add current file to QuickFix" })
--
-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	pattern = "*",
-- 	group = vim.api.nvim_create_augroup("qf", { clear = true }),
-- 	callback = function()
-- 		if vim.bo.buftype == "quickfix" then
-- 			vim.keymap.set("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
-- 			vim.keymap.set("n", "dd", function()
-- 				local idx = vim.fn.line('.')
-- 				local qflist = vim.fn.getqflist()
-- 				table.remove(qflist, idx)
-- 				vim.fn.setqflist(qflist, 'r')
-- 			end, { buffer = true })
-- 		end
-- 	end,
-- })
--
-- vim.keymap.set("n","<C-t>",function()vim.cmd"term"vim.fn.setqflist({{filename=vim.fn.expand"%",lnum=1,col=1}},"a")end,{silent=true})
