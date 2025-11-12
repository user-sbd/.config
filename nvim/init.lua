
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
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
	-- LSP CONFIG
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	-- PREVIEWS
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/barrett-ruth/live-server.nvim" },
	{ src = "https://github.com/SylvanFranklin/omni-preview.nvim" },
	{ src = "https://github.com/toppair/peek.nvim" },
})

require('omni-preview').setup({})
require('live-server').setup({})
require('peek').setup({ app = "browser" })
require("mason").setup()
require("oil").setup({ view_options = { show_hidden = true, }, })

require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls", "clangd", "emmet_ls", "glsl_analyzer", "gopls", "html",
		"lua_ls", "marksman", "ruff", "rust_analyzer", "svelte", "tailwindcss", "tinymist", "jsonls",
	},
	automatic_installation = true,
	automatic_enable = true,
})

vim.g.mapleader = " "
local map = vim.keymap.set

map({ 'n', 'v', 'x' }, '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>v', ':e $MYVIMRC<CR>')
map('n', '<leader>z', ':e ~/.zshrc<CR>')
map({ 'v', 'x', 'n' }, '<C-y>', '"+y', { desc = 'System clipboard yank.' })
map({ 'n', 'v' }, '<leader>n', ':norm ')
map({ 'x', 'n' }, '<C-s>', [[<esc>:'<,'>s/\V/]])
map('n', '-', ':Oil<CR>', { silent = true })
map('n', '<esc>', ':nohlsearch <CR>', { silent = true })
map('n', '<leader>p', ':OmniPreview start<CR>', { silent = true })
map('n', '<leader>cd', '<Cmd>cd %:p:h<CR>', { silent = true })
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

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
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi statusline guifg=white")
vim.cmd("hi ModeMsg guifg=#cdcdcd")
vim.cmd("hi Cursor guifg=white guibg=white")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	callback = function()
		map("n", "<leader>m", ":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR><CR>",
			{ noremap = true, buffer = true })
	end,
})


if vim.fn.executable "rg" == 1 then
    function _G.RgFindFiles(cmdarg, _cmdcomplete)
        local fnames = vim.fn.systemlist('rg --files --hidden --color=never --glob="!.git"')
        if #cmdarg == 0 then
            return fnames
        else
            return vim.fn.matchfuzzy(fnames, cmdarg)
        end
    end
    vim.o.findfunc = 'v:lua.RgFindFiles'
end
local function is_cmdline_type_find()
    local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
    return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end
vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    pattern = { '*' },
    group = vim.api.nvim_create_augroup('CmdlineAutocompletion', { clear = true }),
    callback = function(ev)
        local function should_enable_autocomplete()
            local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
            return is_cmdline_type_find() or cmdline_cmd == 'help' or cmdline_cmd == 'h'
        end
        if ev.event == 'CmdlineChanged' and should_enable_autocomplete() then
            vim.opt.wildmode = 'noselect:lastused,full'
            vim.fn.wildtrigger()
        end
        if ev.event == 'CmdlineLeave' then
            vim.opt.wildmode = 'full'
        end
    end
})
vim.keymap.set('n', '<leader>fj', ':find<space>', { desc = 'Fuzzy find' })
vim.keymap.set('c', '<C-;>', function()
    if not is_cmdline_type_find() then
        vim.notify('This binding should be used with :find', vim.log.levels.ERROR)
        return
    end
    local cmdline_arg = vim.fn.split(vim.fn.getcmdline(), ' ')[2]
    if vim.uv.fs_realpath(vim.fn.expand(cmdline_arg)) == nil then
        vim.notify('The second argument should be a valid path', vim.log.levels.ERROR)
        return
    end
    local keys = vim.api.nvim_replace_termcodes(
        '<C-U>edit ' .. vim.fs.dirname(cmdline_arg),
        true,
        true,
        true
    )
    vim.fn.feedkeys(keys, 'c')
end, { desc = 'Edit the dir for the path' })
vim.keymap.set('c', '<c-v>', '<home><s-right><c-w>vs<end>', { desc = 'Change command to :vs' })

vim.keymap.set("n", "<C-q>", ":copen<CR>", { silent = true })
for i = 1, 9 do
	vim.keymap.set('n', '<leader>' .. i, ':cc ' .. i .. '<CR>', { noremap = true, silent = true })
end
vim.keymap.set("n", "<leader>a",
	function() vim.fn.setqflist({ { filename = vim.fn.expand("%"), lnum = 1, col = 1, text = vim.fn.expand("%"), } }, "a") end,
	{ desc = "Add current file to QuickFix" })

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			vim.keymap.set("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			vim.keymap.set("n", "dd", function()
				local idx = vim.fn.line('.')
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, 'r')
			end, { buffer = true })
		end
	end,
})

