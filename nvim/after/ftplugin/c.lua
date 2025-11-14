-- Set compiler options for quickfix (compilation only)
vim.bo.makeprg = 'gcc -Wall -o %< %'
vim.bo.errorformat = '%f:%l:%c: %m,%f:%l: %m'

