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
  { src = "https://github.com/vague-theme/vague.nvim" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/SalarAlo/rndr.nvim" },
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
  fzf_args = {
    --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#011627,bg+:#262626
    --color=hl:#FFFFFF,hl+:#5fd7ff,info:#FFFFFF,marker:#87ff00
    --color=prompt:#FFFFFF,spinner:#011627,pointer:#ffffff,header:#011627
    --color=gutter:#011627,border:#262626,separator:#011627,scrollbar:#011627
    --color=preview-scrollbar:#011627,label:#aeaeae,query:#d9d9d9
    --border="rounded" --border-label="" --preview-window="border-sharp" --prompt="> "
    --marker=" " --pointer="." --separator="─" --scrollbar="│"
  },
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
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    fullscreen = true,
    preview = {
      border = { "", "", "", "", "", "", "", "" },
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

vim.cmd("colorscheme vague")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
-- vim.cmd("hi SignColumn guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
-- vim.cmd("hi FloatBorder guibg=NONE")
-- vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
-- vim.cmd("hi QuickFixLine guifg = #7AA2F7")
vim.cmd("hi StatusLine guifg=#FFFFFF guibg=none")
vim.cmd("hi TabLine guibg=NONE")
vim.cmd("hi TermStatusNC guibg=NONE")
vim.cmd("hi TabLineFill guibg=#141415")

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

require("rndr").setup({
  preview = {
    auto_open = true,
    events = { "BufReadPost" },
    render_on_resize = true,
  },
  assets = {
    images = { "png", "jpg", "jpeg", "gif", "bmp", "webp" },
    vectors = { "svg", "svgz" },
    models = { "obj", "fbx", "glb", "gltf", "dae", "blend", "ply", "stl" },
  },
  window = {
    termguicolors = true,
    size = { width_offset = 0, height_offset = 0, min_width = 1, min_height = 1, },
    options = { number = false, relativenumber = false, wrap = false, signcolumn = "no", },
  },
  renderer = {
    bin = "/Users/nitin/.local/share/nvim/site/pack/core/opt/rndr.nvim/renderer/build/rndr",
    supersample = 2,
    brightness = 1.0,
    saturation = 1.18,
    contrast = 1.08,
    gamma = 0.92,
    background = "0d0f14",
  },
  controls = {
    rotate_step = 15,
    keymaps = {
      close = "q",
      rerender = "R",
      reset_view = "0",
      rotate_left = "h",
      rotate_right = "l",
      rotate_up = "k",
      rotate_down = "j",
    },
  },
})
