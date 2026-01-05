-- ~/.config/nvim/after/ftplugin/c.lua

local function compile_and_run()
  vim.cmd('w')  -- Save the file

  local file_path   = vim.fn.expand('%:p')           -- full path to .c file
  local file_dir    = vim.fn.expand('%:p:h')         -- directory
  local binary_name = vim.fn.expand('%:t:r')         -- binary name (e.g. main)

  -- Command that:
  -- 1. cds to file directory
  -- 2. compiles
  -- 3. if success: clears screen and runs the program
  local cmd = string.format(
    [[cd %s && gcc %s -o %s && ./%s]],
    vim.fn.shellescape(file_dir),
    vim.fn.shellescape(file_path),
    vim.fn.shellescape(binary_name),
    vim.fn.shellescape(binary_name)
  )

  -- Open small bottom terminal
  vim.cmd('terminal')

  -- Send the command
  local chan = vim.b.terminal_job_id
  if chan then
    vim.api.nvim_chan_send(chan, cmd .. '\n')
  end

  -- Enter insert mode immediately
  vim.cmd('startinsert')
end

vim.keymap.set('n', '<leader>m', compile_and_run, {
  buffer = true,
  desc = 'Compile C file and run (clear screen on success)',
})
