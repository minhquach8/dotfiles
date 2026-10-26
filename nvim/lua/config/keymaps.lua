-- ~/.config/nvim/lua/config/keymaps.lua
-- Global keymaps (not tied to LSP).

vim.g.mapleader = " "

local map = vim.keymap.set

-- Save / quit
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })

-- Seamless navigation between Neovim splits and tmux panes
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Navigate left" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Navigate down" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Navigate up" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Navigate right" })

-- Clear search highlight
map("n", "<leader><space>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Leave insert mode quickly
map("i", "kj", "<Esc>")
