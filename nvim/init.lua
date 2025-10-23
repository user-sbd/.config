vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.o.winborder = "rounded"
vim.o.winbar = ""
vim.o.tabstop = 2
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.guicursor = ""
vim.o.undofile = true
vim.o.signcolumn = 'yes:1'
vim.o.wrap = false

vim.pack.add({
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },

	-- LSP CONFIG
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },

	-- PREVIEWS
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/barrett-ruth/live-server.nvim" },
	{ src = "https://github.com/SylvanFranklin/omni-preview.nvim" },
	{ src = "https://github.com/toppair/peek.nvim" },

	-- GIT
	{ src = "https://github.com/pwntester/octo.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

require"octo".setup({
  picker = "fzf-lua",                    -- or "fzf-lua" or "snacks"
  picker_config = {
    use_emojis = true,                    -- only used by "fzf-lua" picker for now
  },
  comment_icon = "▎",                      -- comment marker
  outdated_icon = "󰅒 ",                    -- outdated indicator
  resolved_icon = " ",                    -- resolved indicator
  reaction_viewer_hint_icon = " ",        -- marker for user reactions
  commands = {},                           -- additional subcommands made available to `Octo` command
  users = "search",                        -- Users for assignees or reviewers. Values: "search" | "mentionable" | "assignable"
  user_icon = " ",                        -- user icon
  ghost_icon = "󰊠 ",                       -- ghost icon
  timeline_marker = " ",                  -- timeline marker
  timeline_indent = 2,                   -- timeline indentation
  use_timeline_icons = true,               -- toggle timeline icons
  timeline_icons = {                       -- the default icons based on timelineItems
    commit = "  ",
    label = "  ",
    reference = " ",
    connected = "  ",
    subissue = "  ",
    cross_reference = "  ",
    parent_issue = "  ",
    pinned = "  ",
    milestone = "  ",
    renamed = "  ",
    merged = { "  ", "OctoPurple" },
    closed = {
      closed = { "  ", "OctoRed" },
      completed = { "  ", "OctoPurple" },
      not_planned = { "  ", "OctoGrey" },
      duplicate = { "  ", "OctoGrey" },
    },
    reopened = { "  ", "OctoGreen" },
    assigned = "  ",
    review_requested = "  ",
  },
  right_bubble_delimiter = "",            -- bubble delimiter
  left_bubble_delimiter = "",             -- bubble delimiter
  github_hostname = "",                    -- GitHub Enterprise host
  snippet_context_lines = 4,               -- number or lines around commented lines
  gh_cmd = "gh",                           -- Command to use when calling Github CLI
  gh_env = {},                             -- extra environment variables to pass on to GitHub CLI, can be a table or function returning a table
  timeout = 5000,                          -- timeout for requests between the remote server
  default_to_projects_v2 = false,          -- use projects v2 for the `Octo card ...` command by default. Both legacy and v2 commands are available under `Octo cardlegacy ...` and `Octo cardv2 ...` respectively.
  ui = {
    use_signcolumn = false,                -- show "modified" marks on the sign column
    use_signstatus = true,                 -- show "modified" marks on the status column
  },
  file_panel = {
    size = 10,                             -- changed files panel rows
    use_icons = false
  },
  colors = {                               -- used for highlight groups (see Colors section below)
    white = "#ffffff",
    grey = "#2A354C",
    black = "#000000",
    red = "#fdb8c0",
    dark_red = "#da3633",
    green = "#acf2bd",
    dark_green = "#238636",
    yellow = "#d3c846",
    dark_yellow = "#735c0f",
    blue = "#58A6FF",
    dark_blue = "#0366d6",
    purple = "#6f42c1",
  },
  mappings_disable_default = false,        -- disable default mappings if true, but will still adapt user mappings
})


require("fzf-lua").setup({
	fzf_colors = true,
	winopts = {
		height = 1,
		width = 1,
		row = 0,
		col = 0,
		border = "rounded",
		title_pos = 'left',
		fullscreen = true
	},
	preview = {
		hidden = true,
	},
	file_icon_padding = "",
	previewers = {
		bat = true,
	},
	files = {
		prompt = "> ",
		previewer = false,
	},
	oldfiles = {
		prompt = "> ",
		previewer = false,
	},
	buffers = {
		prompt = "> ",
		previewer = false,
	},
	quickfix = {
		prompt = "> ",
	},
	loclist = {
		prompt = "> ",
	},
	grep = {
		prompt = "> ",
		input_prompt = "> ",
	},
	live_grep = {
		prompt = "> ",
		input_prompt = "> ",
	},
	tags = {
		prompt = "> ",
	},
	colorschemes = {
		prompt = "> ",
		previewer = false,
		live_preview = true,
	},
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
require("luasnip").setup({ enable_autosnippets = true })
local ls = require("luasnip")

require 'omni-preview'.setup({})
require 'live-server'.setup({})
require 'peek'.setup({ app = "browser" })

require("mason").setup()
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
})

vim.cmd("colorscheme moonfly")

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls", "clangd", "emmet_ls", "glsl_analyzer", "gopls", "html",
		"lua_ls", "marksman", "ruff", "rust_analyzer", "svelte", "tailwindcss", "tinymist",
		"jsonls",
	},
	automatic_installation = true,
	automatic_enable = true,
})

local map = vim.keymap.set

vim.g.mapleader = " "
map({ 'n', 'v', 'x' }, '<leader>lf', vim.lsp.buf.format, { desc = 'Format current buffer' })
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'v', 'x', 'n' }, '<C-y>', '"+y', { desc = 'System clipboard yank.' })
map({ 'i', 's' }, '<C-e>', function() ls.expand_or_jump(1) end, { silent = true })
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'x', 'n' }, '<C-s>', [[<esc>:'<,'>s/\V/]])
map('n', '<leader>fj', ':FzfLua files<CR>', { silent = true })
map('n', '<leader>sh', ':FzfLua helptags<CR>', { silent = true })
map('n', '<leader>fs', ':FzfLua live_grep<CR>', { silent = true })
map('n', '<leader>cs', ':FzfLua colorschemes<CR>', { silent = true })
map('n', '<leader>cf', ':FzfLua files cwd=~/.config<CR>', { silent = true })
map('n', '<leader>gc', ':FzfLua git_commits<CR>', { silent = true })
map('n', '<leader>gs', ':FzfLua git_status<CR>', { silent = true })
map('n', '-', ':Oil<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>p', ':OmniPreview start<CR>', { silent = true })
map('n', '<leader>cd', '<Cmd>cd %:p:h<CR>', { silent = true })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

vim.cmd [[set completeopt=menu,menuone,noselect]]

vim.cmd(":hi statusline guibg=NONE")
vim.cmd(":hi statusline guifg=white")
vim.cmd(":hi ModeMsg guifg=#cdcdcd")

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a", function()
	vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%") }, }, "a")
end)

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line('.')
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, 'r')
			end, { buffer = true })
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map("n", "<leader>m",
			":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true })
	end,
})

map("n", "<leader>m", ":make<CR>", { noremap = true, silent = true })

map("n", "<leader>gr", ":GitHubRepos<CR>", { noremap = true, silent = true })
map("n", "<leader>ra", ":AddGitHubRepo " )

local fzf = require('fzf-lua')
local vim = vim
local repo_file = vim.fn.stdpath('data') .. '/github_repos.txt'

if vim.fn.filereadable(repo_file) == 0 then
  vim.fn.writefile({}, repo_file)
end

local function add_repo(repo)
  local lines = vim.fn.readfile(repo_file)
  for _, l in ipairs(lines) do
    if l == repo then
      return
    end
  end
  table.insert(lines, repo)
  vim.fn.writefile(lines, repo_file)
end

local function pick_github_repo_and_list_issues()
  local lines = vim.fn.readfile(repo_file)
  if #lines == 0 then
    vim.notify("No GitHub repos saved yet", vim.log.levels.WARN)
    return
  end

  fzf.fzf_exec(lines, {
    prompt = 'GitHub Repo > ',
    actions = {
      ['default'] = function(selected)
        local repo = selected[1]
        vim.cmd(string.format("Octo issue list %s", repo))
      end
    }
  })
end

vim.api.nvim_create_user_command('GitHubRepos', function()
  pick_github_repo_and_list_issues()
end, {})

vim.api.nvim_create_user_command('AddGitHubRepo', function(opts)
  local repo = opts.args
  if repo == '' then
    vim.notify("Usage: :AddGitHubRepo owner/repo", vim.log.levels.ERROR)
    return
  end
  add_repo(repo)
  vim.notify("Added repo: " .. repo, vim.log.levels.INFO)
end, { nargs = 1 })

