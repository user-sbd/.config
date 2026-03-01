vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/blazkowolf/gruber-darker.nvim" },
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
	{ src = "https://github.com/leafOfTree/vim-svelte-plugin" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

local opt = vim.opt
local map = vim.keymap.set

vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
opt.winborder = "rounded"
opt.tabstop = 2
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
opt.statusline = "[%n] %<%f %w%m%r%=%-14.(%l,%c%V%) "
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

require("flutter-tools").setup {
	dev_log = {
		enabled = true,
		filter = nil,
		notify_errors = true,
		open_cmd = "10split",
		focus_on_open = false,
	}
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
		"permissions",
		"size",
	},
	buf_options = { buflisted = true, },
	win_options = { signcolumn = "yes:1", },
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	constrain_cursor = "editable",
	keymaps = { ['<C-s>'] = false },

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
	"basedpyright",
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

vim.cmd("colorscheme vague")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi StatusLine guifg=#FFFFFF guibg=none")
vim.cmd("hi SignColumn guibg=none")
vim.cmd("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.cmd("hi FloatBorder guibg=NONE")
vim.cmd("hi WinSeparator guifg=NONE guibg=NONE")
vim.cmd("hi QuickFixLine guifg = #7AA2F7")
vim.cmd("hi Pmenu guibg=NONE")
vim.cmd("hi PmenuBorder guibg=NONE")
vim.cmd("hi LineNr guibg=NONE")
vim.cmd("hi FugitiveHeader guibg=#48484A guifg=#FFFFFF")

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
local ls = require("luasnip")

map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })

map("n", "<leader>f", ":FzfLua files<CR>", { silent = true })
map("n", "<C-f>", ":FzfLua files<CR>", { silent = true })
map("n", "<leader>b", ":FzfLua buffers<CR>", { silent = true })
map("n", "<leader>o", ":FzfLua oldfiles<CR>", { silent = true })
map("n", "<leader>h", ":FzfLua helptags<CR>", { silent = true })
map("n", "<leader>g", ":FzfLua live_grep<CR>", { silent = true })
map("n", "<leader>t", ":FzfLua colorschemes<CR>", { silent = true })
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
map("n", "<S-h>", "<Cmd>vertical resize -8<CR>", { desc = "Decrease width faster" })
map("n", "<S-l>", "<Cmd>vertical resize +8<CR>", { desc = "Increase width faster" })

map("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	map('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end

map("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })

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

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

local term_win = nil
local term_buf = nil
local term_job_id = nil

_G.toggle_term = function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil
		return
	end
	local cwd
	if vim.bo.filetype == "oil" or vim.b.oil then
		cwd = require("oil").get_current_dir(0)
	else
		cwd = vim.fn.expand("%:p:h")
	end
	if not cwd or cwd == "" then
		cwd = vim.fn.getcwd()
	end
	if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("belowright 10split | terminal")
		term_buf = vim.api.nvim_get_current_buf()
		term_win = vim.api.nvim_get_current_win()
		term_job_id = vim.b.terminal_job_id
		vim.bo[term_buf].bufhidden = "hide"
		vim.bo[term_buf].filetype = "toggleterm"
		vim.api.nvim_create_autocmd("BufDelete", {
			buffer = term_buf,
			callback = function()
				term_buf = nil
				term_win = nil
				term_job_id = nil
			end,
			once = true
		})
	else
		vim.cmd("belowright 10split")
		term_win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term_win, term_buf)
	end
	vim.fn.chdir(cwd)
	if term_job_id and vim.fn.jobwait({ term_job_id }, 0) == -1 then
		vim.fn.chansend(term_job_id, "cd " .. vim.fn.fnameescape(cwd) .. "\n")
	end
	vim.cmd("startinsert")
end

_G.run_in_terminal = function(cmd)
	vim.cmd("write")
	_G.toggle_term()
	vim.defer_fn(function()
		if term_job_id and vim.fn.jobwait({ term_job_id }, 0) == -1 then
			vim.fn.chansend(term_job_id, cmd .. "\n")
		else
			vim.api.nvim_feedkeys(cmd .. "\r", "t", false)
		end
		vim.cmd("startinsert")
	end, 50)
end
vim.keymap.set({ "n", "t" }, "<C-s>", _G.toggle_term, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>m", function()
	local cmd = vim.b.run_command
	if cmd then
		_G.run_in_terminal(cmd)
	else
		vim.notify("No run command for " .. vim.bo.filetype, vim.log.levels.WARN)
	end
end)


local neogit = require("neogit")

neogit.setup {
  -- Hides the hints at the top of the status buffer
  disable_hint = false,
  -- Disables changing the buffer highlights based on where the cursor is.
  disable_context_highlighting = false,
  -- Disables signs for sections/items/hunks
  disable_signs = false,
  -- Path to git executable. Defaults to "git". Can be used to specify a custom git binary or wrapper script.
  git_executable = "git",
  -- Offer to force push when branches diverge
  prompt_force_push = true,
  -- Request confirmation when amending already published commits
  prompt_amend_commit = true,
  -- Changes what mode the Commit Editor starts in. `true` will leave nvim in normal mode, `false` will change nvim to
  -- insert mode, and `"auto"` will change nvim to insert mode IF the commit message is empty, otherwise leaving it in
  -- normal mode.
  disable_insert_on_commit = "auto",
  -- When enabled, will watch the `.git/` directory for changes and refresh the status buffer in response to filesystem
  -- events.
  filewatcher = {
    interval = 1000,
    enabled = true,
  },
  -- "ascii"   is the graph the git CLI generates
  -- "unicode" is the graph like https://github.com/rbong/vim-flog
  -- "kitty"   is the graph like https://github.com/isakbm/gitgraph.nvim - use https://github.com/rbong/flog-symbols if you don't use Kitty
  graph_style = "ascii",
  -- Show relative date by default. When set, use `strftime` to display dates
  commit_date_format = nil,
  log_date_format = nil,
  -- Show message with spinning animation when a git command is running.
  process_spinner = false,
  -- Used to generate URL's for branch popup action "pull request", "open commit" and "open tree"
  git_services = {
    ["github.com"] = {
      pull_request = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      commit = "https://github.com/${owner}/${repository}/commit/${oid}",
      tree = "https://${host}/${owner}/${repository}/tree/${branch_name}",
    },
    ["bitbucket.org"] = {
      pull_request = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
      commit = "https://bitbucket.org/${owner}/${repository}/commits/${oid}",
      tree = "https://bitbucket.org/${owner}/${repository}/branch/${branch_name}",
    },
    ["gitlab.com"] = {
      pull_request = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      commit = "https://gitlab.com/${owner}/${repository}/-/commit/${oid}",
      tree = "https://gitlab.com/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
    },
    ["azure.com"] = {
      pull_request = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
      commit = "",
      tree = "",
    },
    ["codeberg.org"] = {
      pull_request = "https://${host}/${owner}/${repository}/compare/${branch_name}",
      commit = "https://${host}/${owner}/${repository}/commit/${oid}",
      tree = "https://${host}/${owner}/${repository}/src/branch/${branch_name}",
    },
  },
  -- Allows a different telescope sorter. Defaults to 'fuzzy_with_index_bias'. The example below will use the native fzf
  -- sorter instead. By default, this function returns `nil`.
  telescope_sorter = function()
    return require("telescope").extensions.fzf.native_fzf_sorter()
  end,
  -- Persist the values of switches/options within and across sessions
  remember_settings = true,
  -- Scope persisted settings on a per-project basis
  use_per_project_settings = true,
  -- Table of settings to never persist. Uses format "Filetype--cli-value"
  ignored_settings = {},
  -- Configure highlight group features
  highlight = {
    italic = true,
    bold = true,
    underline = true
  },
  -- Set to false if you want to be responsible for creating _ALL_ keymappings
  use_default_keymaps = true,
  -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
  -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
  auto_refresh = true,
  -- Value used for `--sort` option for `git branch` command
  -- By default, branches will be sorted by commit date descending
  -- Flag description: https://git-scm.com/docs/git-branch#Documentation/git-branch.txt---sortltkeygt
  -- Sorting keys: https://git-scm.com/docs/git-for-each-ref#_options
  sort_branches = "-committerdate",
  -- Value passed to the `--<commit_order>-order` flag of the `git log` command
  -- Determines how commits are traversed and displayed in the log / graph:
  --   "topo"         topological order (parents always before children, good for graphs, slower on large repos)
  --   "date"         chronological order by commit date
  --   "author-date"  chronological order by author date
  --   ""             disable explicit ordering (fastest, recommended for very large repos)
  commit_order = "topo",
  -- Default for new branch name prompts
  initial_branch_name = "",
  -- Default for rename branch prompt. If not set, the current branch name is used
  initial_branch_rename = nil,
  -- Change the default way of opening neogit
  kind = "tab",
  -- Floating window style 
  floating = {
    relative = "editor",
    width = 0.8,
    height = 0.7,
    style = "minimal",
    border = "rounded",
  },
  -- Disable line numbers
  disable_line_numbers = true,
  -- Disable relative line numbers
  disable_relative_line_numbers = true,
  -- The time after which an output console is shown for slow running commands
  console_timeout = 2000,
  -- Automatically show console if a command takes more than console_timeout milliseconds
  auto_show_console = true,
  -- Automatically close the console if the process exits with a 0 (success) status
  auto_close_console = true,
  notification_icon = "󰊢",
  status = {
    show_head_commit_hash = true,
    recent_commit_count = 10,
    HEAD_padding = 10,
    HEAD_folded = false,
    mode_padding = 3,
    mode_text = {
      M = "modified",
      N = "new file",
      A = "added",
      D = "deleted",
      C = "copied",
      U = "updated",
      R = "renamed",
      T = "changed",
      DD = "unmerged",
      AU = "unmerged",
      UD = "unmerged",
      UA = "unmerged",
      DU = "unmerged",
      AA = "unmerged",
      UU = "unmerged",
      ["?"] = "",
    },
  },
  commit_editor = {
    kind = "tab",
    show_staged_diff = true,
    -- Accepted values:
    -- "split" to show the staged diff below the commit editor
    -- "vsplit" to show it to the right
    -- "split_above" Like :top split
    -- "vsplit_left" like :vsplit, but open to the left
    -- "auto" "vsplit" if window would have 80 cols, otherwise "split"
    staged_diff_split_kind = "split",
    spell_check = true,
  },
  commit_select_view = {
    kind = "tab",
  },
  commit_view = {
    kind = "vsplit",
    verify_commit = vim.fn.executable("gpg") == 1, -- Can be set to true or false, otherwise we try to find the binary
  },
  log_view = {
    kind = "tab",
  },
  rebase_editor = {
    kind = "auto",
  },
  reflog_view = {
    kind = "tab",
  },
  merge_editor = {
    kind = "auto",
  },
  preview_buffer = {
    kind = "floating_console",
  },
  popup = {
    kind = "split",
  },
  stash = {
    kind = "tab",
  },
  refs_view = {
    kind = "tab",
  },
  signs = {
    -- { CLOSED, OPENED }
    hunk = { "", "" },
    item = { ">", "v" },
    section = { ">", "v" },
  },
  -- Each Integration is auto-detected through plugin presence, however, it can be disabled by setting to `false`
  integrations = {
    -- If enabled, use telescope for menu selection rather than vim.ui.select.
    -- Allows multi-select and some things that vim.ui.select doesn't.
    telescope = nil,
    -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
    -- The diffview integration enables the diff popup.
    --
    -- Requires you to have `sindrets/diffview.nvim` installed.
    diffview = nil,

    -- Alternative diff viewer integration.
    -- Requires you to have `esmuellert/codediff.nvim` installed.
    codediff = nil,

    -- If enabled, uses fzf-lua for menu selection. If the telescope integration
    -- is also selected then telescope is used instead
    -- Requires you to have `ibhagwan/fzf-lua` installed.
    fzf_lua = nil,

    -- If enabled, uses mini.pick for menu selection. If the telescope integration
    -- is also selected then telescope is used instead
    -- Requires you to have `echasnovski/mini.pick` installed.
    mini_pick = nil,

    -- If enabled, uses snacks.picker for menu selection. If the telescope integration
    -- is also selected then telescope is used instead
    -- Requires you to have `folke/snacks.nvim` installed.
    snacks = nil,
  },
  -- Which diff viewer to use. nil = auto-detect (tries diffview first, then codediff).
  -- Can be "diffview" or "codediff".
  diff_viewer = nil,
  sections = {
    -- Reverting/Cherry Picking
    sequencer = {
      folded = false,
      hidden = false,
    },
    untracked = {
      folded = false,
      hidden = false,
    },
    unstaged = {
      folded = false,
      hidden = false,
    },
    staged = {
      folded = false,
      hidden = false,
    },
    stashes = {
      folded = true,
      hidden = false,
    },
    unpulled_upstream = {
      folded = true,
      hidden = false,
    },
    unmerged_upstream = {
      folded = false,
      hidden = false,
    },
    unpulled_pushRemote = {
      folded = true,
      hidden = false,
    },
    unmerged_pushRemote = {
      folded = false,
      hidden = false,
    },
    recent = {
      folded = true,
      hidden = false,
    },
    rebase = {
      folded = true,
      hidden = false,
    },
  },
  mappings = {
    commit_editor = {
      ["q"] = "Close",
      ["<c-c><c-c>"] = "Submit",
      ["<c-c><c-k>"] = "Abort",
      ["<m-p>"] = "PrevMessage",
      ["<m-n>"] = "NextMessage",
      ["<m-r>"] = "ResetMessage",
    },
    commit_editor_I = {
      ["<c-c><c-c>"] = "Submit",
      ["<c-c><c-k>"] = "Abort",
    },
    rebase_editor = {
      ["p"] = "Pick",
      ["r"] = "Reword",
      ["e"] = "Edit",
      ["s"] = "Squash",
      ["f"] = "Fixup",
      ["x"] = "Execute",
      ["d"] = "Drop",
      ["b"] = "Break",
      ["q"] = "Close",
      ["<cr>"] = "OpenCommit",
      ["gk"] = "MoveUp",
      ["gj"] = "MoveDown",
      ["<c-c><c-c>"] = "Submit",
      ["<c-c><c-k>"] = "Abort",
      ["[c"] = "OpenOrScrollUp",
      ["]c"] = "OpenOrScrollDown",
    },
    rebase_editor_I = {
      ["<c-c><c-c>"] = "Submit",
      ["<c-c><c-k>"] = "Abort",
    },
    finder = {
      ["<cr>"] = "Select",
      ["<c-c>"] = "Close",
      ["<esc>"] = "Close",
      ["<c-n>"] = "Next",
      ["<c-p>"] = "Previous",
      ["<down>"] = "Next",
      ["<up>"] = "Previous",
      ["<tab>"] = "InsertCompletion",
      ["<c-y>"] = "CopySelection",
      ["<space>"] = "MultiselectToggleNext",
      ["<s-space>"] = "MultiselectTogglePrevious",
      ["<c-j>"] = "NOP",
      ["<ScrollWheelDown>"] = "ScrollWheelDown",
      ["<ScrollWheelUp>"] = "ScrollWheelUp",
      ["<ScrollWheelLeft>"] = "NOP",
      ["<ScrollWheelRight>"] = "NOP",
      ["<LeftMouse>"] = "MouseClick",
      ["<2-LeftMouse>"] = "NOP",
    },
    -- Setting any of these to `false` will disable the mapping.
    popup = {
      ["?"] = "HelpPopup",
      ["A"] = "CherryPickPopup",
      ["d"] = "DiffPopup",
      ["M"] = "RemotePopup",
      ["P"] = "PushPopup",
      ["X"] = "ResetPopup",
      ["Z"] = "StashPopup",
      ["i"] = "IgnorePopup",
      ["t"] = "TagPopup",
      ["b"] = "BranchPopup",
      ["B"] = "BisectPopup",
      ["w"] = "WorktreePopup",
      ["c"] = "CommitPopup",
      ["f"] = "FetchPopup",
      ["l"] = "LogPopup",
      ["m"] = "MergePopup",
      ["p"] = "PullPopup",
      ["r"] = "RebasePopup",
      ["v"] = "RevertPopup",
    },
    status = {
      ["j"] = "MoveDown",
      ["k"] = "MoveUp",
      ["o"] = "OpenTree",
      ["q"] = "Close",
      ["I"] = "InitRepo",
      ["1"] = "Depth1",
      ["2"] = "Depth2",
      ["3"] = "Depth3",
      ["4"] = "Depth4",
      ["Q"] = "Command",
      ["<tab>"] = "Toggle",
      ["za"] = "Toggle",
      ["zo"] = "OpenFold",
      ["x"] = "Discard",
      ["s"] = "Stage",
      ["S"] = "StageUnstaged",
      ["<c-s>"] = "StageAll",
      ["u"] = "Unstage",
      ["K"] = "Untrack",
      ["U"] = "UnstageStaged",
      ["y"] = "ShowRefs",
      ["$"] = "CommandHistory",
      ["Y"] = "YankSelected",
      ["gp"] = "GoToParentRepo",
      ["<c-r>"] = "RefreshBuffer",
      ["<cr>"] = "GoToFile",
      ["<s-cr>"] = "PeekFile",
      ["<c-v>"] = "VSplitOpen",
      ["<c-x>"] = "SplitOpen",
      ["<c-t>"] = "TabOpen",
      ["{"] = "GoToPreviousHunkHeader",
      ["}"] = "GoToNextHunkHeader",
      ["[c"] = "OpenOrScrollUp",
      ["]c"] = "OpenOrScrollDown",
      ["<c-k>"] = "PeekUp",
      ["<c-j>"] = "PeekDown",
      ["<c-n>"] = "NextSection",
      ["<c-p>"] = "PreviousSection",
    },
  },
}
