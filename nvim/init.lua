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
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/folke/snacks.nvim" },
})

local opt = vim.opt
local map = vim.keymap.set

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
opt.expandtab = true
opt.showtabline = 2
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

require("fzf-lua").setup({
  fzf_opts = {
    ["--ansi"] = true,
    ["--info"] = "inline-right",
    ["--height"] = "100%",
    ["--border"] = "none",
  },
  winopts = {
    title_flags = false,
    height = 15,
    width = 50,
    row = 1,
    col = 0,
    -- border = { " ", " ", " ", " ", " ", " ", " ", " " },
    fullscreen = true,
    preview = {
      -- border = { "", "", "", "", "", "", "", "" },
      horizontal = "right:40%",
      layout = "horizontal",
    },
  },
  actions = {
    files = {
      ["enter"]  = require("fzf-lua.actions").file_edit_or_qf,
      ["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
      ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
    },
  },
  files = { prompt = "> ", title = "f" },
  oldfiles = { prompt = "> " },
  previewers = { bat = true },
  file_icon_padding = "",
})


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

vim.cmd("colorscheme material-darker")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi Cursor guibg=#E8E8E9")
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

map("n", "<leader>f", ":FzfLua files<CR>", { silent = true })
map("n", "<C-f>", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>o", ":FzfLua oldfiles<CR>", { silent = true })
map("n", "<leader>h", ":FzfLua helptags<CR>", { silent = true })
map("n", "<leader>g", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>c", ":FzfLua files cwd=~/.config<CR>", { silent = true })

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

map({ "n" }, "<leader>x", "<Cmd>tabclose<CR>")
map({ "n", "t" }, "<C-x>", "<Cmd>tabclose<CR>")
map({ "n", "t" }, "<C-t>", "<Cmd>tabnew<CR>")
map("n", "<C-n>", "<CMD>tabnext<CR>")
map("n", "<C-p>", "<CMD>tabprevious<CR>")
for i = 1, 8 do
  map("n", "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end


  require('snacks').setup({
    bigfile = { enabled = true },
    explorer = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    styles = {
    }
  })


  -- Top Pickers & Explorer
map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })

-- Find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })

map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })

-- Grep
map("n", "<leader>g", function() Snacks.picker.grep() end, { desc = "Grep" })

-- Search
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- Other
map("n", "<leader>z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Select Scratch Buffer" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })

