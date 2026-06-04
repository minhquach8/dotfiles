-- ~/.config/nvim/lua/config/autocmds.lua
-- General autocmds not tied to a specific plugin.

-- When you use multiple tmux panes or external tools (git, formatters, etc.)
-- files on disk can change without Neovim knowing.
-- This autocmd runs :checktime whenever:
--   - Neovim regains focus (FocusGained)
--   - you enter any buffer (BufEnter)
-- so Neovim will detect and reload changed files when needed.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
