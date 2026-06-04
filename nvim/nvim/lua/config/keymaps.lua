-- ~/.config/nvim/lua/config/keymaps.lua
-- Global keymaps (not tied to LSP).

vim.g.mapleader = " "

local map = vim.keymap.set

-- Save / quit
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>",  { desc = "Quit window" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Clear search highlight
map("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Leave insert mode quickly
map("i", "kj", "<Esc>")
