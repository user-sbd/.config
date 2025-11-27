vim.bo.makeprg = "gcc -Wall -Wextra -o %< %"

vim.keymap.set("n", "<leader>m", function()
  vim.cmd([[silent !gcc -Wall -Wextra -o %< % && tmux split-window -v -p 30 '%< ; read']])
  vim.cmd("redraw!")
end, { buffer = true })
