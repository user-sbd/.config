#!/usr/bin/env bash
set -e

NVIMDIR="${HOME}/.config/nvim"
FTDIR="${NVIMDIR}/ftplugin"
INIT="${NVIMDIR}/init.lua"

mkdir -p "$FTDIR"

# Create ftplugin/python.lua
cat > "$FTDIR/python.lua" << 'EOF'
-- ftplugin/python.lua
vim.bo.makeprg = "python3 %"
EOF

# Create ftplugin/rust.lua
cat > "$FTDIR/rust.lua" << 'EOF'
-- ftplugin/rust.lua
if vim.fn.filereadable("Cargo.toml") == 1 then
  vim.bo.makeprg = "cargo run"
else
  vim.bo.makeprg = "rustc % && ./%:r"
end
EOF

# Create ftplugin/c.lua
cat > "$FTDIR/c.lua" << 'EOF'
-- ftplugin/c.lua
vim.bo.makeprg = "gcc % -o %:r && ./%:r"
EOF

# Create ftplugin/cpp.lua
cat > "$FTDIR/cpp.lua" << 'EOF'
-- ftplugin/cpp.lua
vim.bo.makeprg = "g++ % -o %:r && ./%:r"
EOF

# Create ftplugin/cs.lua
cat > "$FTDIR/cs.lua" << 'EOF'
-- ftplugin/cs.lua
vim.bo.makeprg = "dotnet run"
EOF

# Create ftplugin/typst.lua
cat > "$FTDIR/typst.lua" << 'EOF'
-- ftplugin/typst.lua
-- build typst and open PDF
vim.bo.makeprg = "typst compile % -o %:r.pdf"
vim.api.nvim_buf_set_keymap(
  0,
  "n",
  "<leader>m",
  ":make<CR>:lua vim.fn.jobstart('zathura ' .. vim.fn.expand('%:r') .. '.pdf &')<CR>",
  { noremap = true, silent = true }
)
EOF

# Ensure init.lua exists
if [ ! -f "$INIT" ]; then
  cat > "$INIT" << 'EOF'
-- Initial Neovim config

-- Enable filetype plugin (if needed)
vim.cmd("filetype plugin on")

-- Global <leader>m mapping
vim.keymap.set("n", "<leader>m", ":make<CR>", { noremap = true, silent = true })

-- ... your other config here ...
EOF
else
  # If init.lua already exists, just append mapping if missing
  if ! grep -q "vim.keymap.set(\"n\", \"<leader>m\"" "$INIT"; then
    cat >> "$INIT" << 'EOF'

-- Global <leader>m mapping for make
vim.keymap.set("n", "<leader>m", ":make<CR>", { noremap = true, silent = true })
EOF
  fi
  # Also ensure filetype plugin is enabled
  if ! grep -q "filetype plugin on" "$INIT"; then
    cat >> "$INIT" << 'EOF'

-- enable filetype plugins
vim.cmd("filetype plugin on")
EOF
  fi
fi

echo "Scaffolded ftplugin files in $FTDIR and updated $INIT"

