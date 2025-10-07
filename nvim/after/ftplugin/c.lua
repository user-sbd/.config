-- ftplugin/c.lua
vim.bo.makeprg = "gcc % -o %:r && ./%:r"
