-- ftplugin/rust.lua
if vim.fn.filereadable("Cargo.toml") == 1 then
  vim.bo.makeprg = "cargo run"
else
  vim.bo.makeprg = "rustc % && ./%:r"
end
