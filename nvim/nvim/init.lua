-- ~/.config/nvim/init.lua
-- Entry point: delegate to small, focused modules in lua/config/*.

require("config.options")   -- basic vim.opt settings
require("config.keymaps")   -- global keymaps (non-LSP)
require("config.autocmds")  -- general autocmds (checktime, etc.)
require("config.lazy")      -- plugin manager + plugins via lazy.nvim
require("config.lsp")       -- language servers, LSP keymaps, formatting

