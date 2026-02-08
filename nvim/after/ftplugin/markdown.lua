vim.pack.add({
	{ src = "https://github.com/toppair/peek.nvim" },
})

vim.opt.wrap = true
vim.opt.linebreak = true

require("peek").setup()
vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
vim.keymap.set("n", "<leader>p", "<CMD>PeekOpen<CR>")
