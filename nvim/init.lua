vim.pack.add({
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/L3MON4D3/LuaSnip" },
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/ej-shafran/compile-mode.nvim" },
  { src = "https://github.com/marko-cerovac/material.nvim" },
  { src = "https://github.com/bluz71/vim-moonfly-colors" },
  { src = "https://github.com/folke/snacks.nvim" },
})

local opt = vim.opt
local map = vim.keymap.set

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
opt.statusline = '[%n] %<%f %h%w%m%r%=%-14.(%l,%c%V%) %P'
opt.expandtab = true
opt.showtabline = 0
opt.inccommand = "split"
opt.shiftwidth = 2
opt.cmdheight = 1
opt.signcolumn = "yes:1"
opt.wrap = false
opt.ignorecase = true
opt.smartindent = true
opt.termguicolors = true
opt.undofile = true
opt.number = true
opt.relativenumber = true
opt.guicursor = ""
opt.winborder = "rounded"
opt.pumborder = "rounded"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('typst-preview').setup {
  -- invert_colors = 'always', --
}

require('nvim-treesitter').setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
  ensure_installed = { "typescript", "css", "javascript", "svelte", "html" },
  highlight = {
    enable = true,
  },
}

require("oil").setup({
  default_file_explorer = true,
  columns = {
    "icon",
  },
  buf_options = { buflisted = true, },
  win_options = { signcolumn = "yes:1", },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  constrain_cursor = "editable",
  keymaps = {
    ['<C-s>'] = false,
    ["<C-t>"] = { "actions.select", opts = { tab = true } },
    ["g\\"] = { "actions.toggle_trash", mode = "n" },
  },
})

require("mason").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.lsp.enable({
  "rust_analyzer", "clangd", "ruff",
  "intelephense", "tailwindcss", "ts_ls",
  "emmet-language-server", "zls",
  "marksman", "bashls", "lua_ls",
  "cssls", "svelte", "tinymist",
  "basedpyright", "vscode-css-language-server",
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.cmd("colorscheme moonfly")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi StatusLine guifg=#FFFFFF guibg=none")
vim.cmd("hi TabLine guibg=none")
vim.cmd("hi TabLineSel guibg=#82AAFF")
vim.cmd("hi TermStatusNC guibg=NONE")
vim.cmd("hi TabLineFill guibg=141415")

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")

map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n" }, "<Esc>", "<Cmd>nohlsearch<CR>")
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ")
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })
map("n", "-", "<cmd>Oil<CR>")
map("n", "<C-g>", ":Git | only<CR>", { silent = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

map("n", "<C-n>", "<CMDBNext><CR>")
map("n", "<C-p>", "<CMD>bprevious<CR>")

require('snacks').setup({
  bigfile = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  explorer = {
    layout = {
      preset = "sidebar", preview = false,
    },
  },
  picker = {
    layout = {
      preset = "telescope",
      layout = {
        width = 0,
        height = 0,
      },
    },
  },
  quickfile = { enabled = true },
  styles = {}
})

local Snacks = require("snacks")
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
map("n", "<leader>b", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n","<leader>e", function() Snacks.explorer() end, {desc = "File Explorer"} )
map("n", "<leader>c", function() Snacks.picker.files({ cwd = '~/.config' }) end,
  { desc = "Find Config File" })
map("n", "<leader>f", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<C-f>", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
map("n", "<leader>of", function() Snacks.picker.recent() end, { desc = "Recent" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
map("n", "<leader>gl", "<CMD>0Gclog<CR>",{ desc = "git log (QF)" })
map("n", "<leader>gs", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>h", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<C-h>", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<C-b>", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<leader>H", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>ss", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
map("n", "<leader>lg", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  Snacks.lazygit({ cwd = dir })
end, { desc = "Lazygit (current file dir)" })
map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })

opt.guicursor = "n-v-c-i:block"

