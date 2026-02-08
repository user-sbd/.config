vim.pack.add({
	{ src = "https://github.com/nvim-flutter/flutter-tools.nvim" },
})

require("flutter-tools").setup {
	dev_log = {
		enabled = true,
		filter = nil,
		notify_errors = false,
		open_cmd = "10split",
		focus_on_open = false,
	}
}
