-- ~/.config/nvim/lua/config/options.lua
-- Core Neovim options (buffer / window / editor behaviour).

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false
opt.signcolumn = "yes"
opt.termguicolors = true
opt.colorcolumn = "100" -- soft guideline column

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.splitright = true
opt.splitbelow = true

-- Visible whitespace
opt.list = true

opt.listchars = {
	tab = "→ ",
	trail = "·",
	nbsp = "␣",
}

-- Use the system clipboard (macOS)
opt.clipboard = "unnamedplus"

-- Persistent undo
local undo_directory = vim.fn.stdpath("state") .. "/undo"

if vim.fn.isdirectory(undo_directory) == 0 then
	vim.fn.mkdir(undo_directory, "p")
end

opt.undofile = true
opt.undodir = undo_directory

-- Disable unused language providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
