vim.bo.makeprg = "gcc % -o %:r"  -- basic compile, supports :make for errors
vim.bo.errorformat = [[%f:%l:%c: %trror: %m,%f:%l:%c: %tarning: %m,%f:%l:%c: %m]]
