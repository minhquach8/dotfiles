-- ~/.config/nvim/lua/config/lazy.lua
-- Bootstrap lazy.nvim and declare all plugins.

if not vim.uv and vim.loop then
	vim.uv = vim.loop
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local map = vim.keymap.set

require("lazy").setup({
	----------------------------------------------------------------
	-- tmux navigation integration
	----------------------------------------------------------------
	{
		"christoomey/vim-tmux-navigator",
	},

	----------------------------------------------------------------
	-- Colourscheme: Catppuccin
	----------------------------------------------------------------
	{
		"catppuccin/nvim",
		priority = 1000,
		config = function()
			vim.o.background = "dark"
			vim.cmd("colorscheme catppuccin-mocha")
			-- Make the ColorColumn visually match the cursorline
			vim.api.nvim_set_hl(0, "ColorColumn", { link = "CursorLine" })
		end,
	},

	----------------------------------------------------------------
	-- Lualine statusline
	----------------------------------------------------------------
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "everforest",
					icons_enabled = true,
					component_separators = "|",
					section_separators = "",
				},
			})
		end,
	},

	----------------------------------------------------------------
	-- Treesitter
	----------------------------------------------------------------
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"bash",
					"vim",
					"markdown",
					"json",
					"yaml",
					"dockerfile",
					"sql",
					"asm",
				},
				highlight = { enable = true },
				indent = { enable = true, disable = { "python" } },
			})
		end,
	},

	----------------------------------------------------------------
	-- Telescope (fd + ripgrep, includes hidden files)
	----------------------------------------------------------------
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					-- Use ripgrep, but include hidden files (except .git)
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!.git/*",
					},
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
						},
					},
				},
				pickers = {
					-- find_files uses fd and shows dotfiles, only hides .git
					find_files = {
						find_command = {
							"fd",
							".", -- current root
							"--type",
							"f",
							"--hidden",
							"--follow",
							"--exclude",
							".git",
						},
					},
				},
			})

			local builtin = require("telescope.builtin")
			local previewers = require("telescope.previewers")

			local function command_exists(command_name)
				return vim.fn.executable(command_name) == 1
			end

			local function get_file_extension(file_path)
				return vim.fn.fnamemodify(file_path, ":e"):lower()
			end

			local function smart_file_previewer()
				return previewers.new_termopen_previewer({
					title = "Smart Preview",

					get_command = function(entry)
						local file_path = entry.path or entry.filename or entry.value
						local extension = get_file_extension(file_path)

						if extension == "pdf" then
							if command_exists("pdftotext") then
								return { "pdftotext", "-layout", "-l", "5", file_path, "-" }
							end

							return { "echo", "PDF preview requires: brew install poppler" }
						end

						if vim.tbl_contains({ "png", "jpg", "jpeg", "webp", "gif", "bmp", "tiff" }, extension) then
							if command_exists("chafa") then
								return { "chafa", "--size=80x40", file_path }
							end

							return { "echo", "Image preview requires: brew install chafa" }
						end

						if
							vim.tbl_contains({ "zip", "tar", "gz", "7z", "dmg", "mp4", "mov", "avi", "mkv" }, extension)
						then
							return { "echo", "Binary or archive file. Preview skipped." }
						end

						if command_exists("bat") then
							return {
								"bat",
								"--style=numbers",
								"--color=always",
								"--line-range=:500",
								file_path,
							}
						end

						return { "sed", "-n", "1,500p", file_path }
					end,
				})
			end
			local opts = { noremap = true, silent = true }

			map("n", "<leader>ff", function()
				builtin.find_files({
					previewer = smart_file_previewer(),
				})
			end, opts)
			map("n", "<leader>fg", builtin.live_grep, opts)
			map("n", "<leader>fb", builtin.buffers, opts)
			map("n", "<leader>fh", builtin.help_tags, opts)
		end,
	},

	----------------------------------------------------------------
	-- Telescope fzf-native: speed up sorting
	----------------------------------------------------------------
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("fzf")
		end,
	},

	----------------------------------------------------------------
	-- Git signs
	----------------------------------------------------------------
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				-- Periodically watch the .git directory so that hunks update
				-- when you commit / checkout from another tmux pane.
				watch_gitdir = {
					interval = 1000, -- check for changes every 1000ms
					follow_files = true, -- follow files across renames
				},

				signs = {
					add = { text = "│" },
					change = { text = "│" },
					delete = { text = "󰍵" },
					topdelete = { text = "‾" },
					changedelete = { text = "│" },
				},

				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local gmap = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					-- Hunk navigation
					gmap("n", "]c", gs.next_hunk, "Next hunk")
					gmap("n", "[c", gs.prev_hunk, "Prev hunk")

					-- Actions
					gmap("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
					gmap("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
					gmap("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
					gmap("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
					gmap("n", "<leader>hb", gs.blame_line, "Git blame line")
				end,
			})
		end,
	},

	----------------------------------------------------------------
	-- Oil.nvim: file explorer in a normal buffer
	----------------------------------------------------------------
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
			})

			vim.keymap.set("n", "<leader>o", "<cmd>Oil<CR>", { desc = "Open file explorer" })
		end,
	},

	----------------------------------------------------------------
	-- Comment.nvim: toggle comments easily
	----------------------------------------------------------------
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()

			-- Toggle comment on the current line
			vim.keymap.set("n", "<leader>/", function()
				return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
					or "<Plug>(comment_toggle_linewise_count)"
			end, { expr = true, desc = "Toggle comment line" })

			-- Toggle comment on the selected block
			vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", {
				desc = "Toggle comment selection",
			})
		end,
	},

	----------------------------------------------------------------
	-- Which-key: show available keybindings in a popup
	----------------------------------------------------------------
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({})
			-- You can add keygroup descriptions later if you want.
		end,
	},

	----------------------------------------------------------------
	-- TODO comments
	----------------------------------------------------------------
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("todo-comments").setup()

			vim.keymap.set("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Todo list (Trouble)" })
		end,
	},

	----------------------------------------------------------------
	-- Indent guides (indent-blankline)
	----------------------------------------------------------------
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("ibl").setup({
				indent = { char = "│" },
				scope = { enabled = false },
			})
		end,
	},

	----------------------------------------------------------------
	-- Trouble: better diagnostics / references list
	----------------------------------------------------------------
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle" },
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Document diagnostics",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Workspace diagnostics",
			},
			{
				"<leader>xr",
				"<cmd>Trouble lsp_references toggle<cr>",
				desc = "LSP references",
			},
		},
	},

	----------------------------------------------------------------
	-- Mason: LSP/DAP/formatter installer
	----------------------------------------------------------------
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	----------------------------------------------------------------
	-- Mason-LSPConfig: install LSP servers, do not auto-enable
	----------------------------------------------------------------
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"pyright",
					"lua_ls",
					"bashls",
					"ts_ls", -- TypeScript / JavaScript
					"eslint", -- ESLint LSP
					"taplo", -- TOML
					"yamlls", -- YAML
					"dockerls", -- Dockerfile
					"sqlls", -- SQL
				},
				automatic_installation = false,
			})
		end,
	},

	----------------------------------------------------------------
	-- Completion: nvim-cmp
	----------------------------------------------------------------
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(_) end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-y>"] = cmp.mapping.complete(), -- Trigger completion
					["<C-e>"] = cmp.mapping.abort(), -- Close menu
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept
					["<C-j>"] = cmp.mapping.select_next_item(), -- Navigate down
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Navigate up
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	----------------------------------------------------------------
	-- Conform: unified formatter manager
	----------------------------------------------------------------
	{
		"stevearc/conform.nvim",
		config = function()
			require("config.format")
		end,
	},

	----------------------------------------------------------------
	-- Markdown Preview (iamcco)
	----------------------------------------------------------------
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = { "markdown" },
		init = function()
			-- Echo the preview URL in the command line
			vim.g.mkdp_echo_preview_url = 1
		end,
	},

	----------------------------------------------------------------
	-- Debugging (DAP)
	----------------------------------------------------------------
	{
		"mfussenegger/nvim-dap",
	},

	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("config.dap")
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup({
				-- Debug adapters to install via Mason
				ensure_installed = {
					"python", -- debugpy
					"node2", -- Node.js / JS / TS
					"cppdbg", -- C/C++ (vscode-cpptools)
				},
				automatic_installation = true,
				handlers = {}, -- use default handler for now
			})
		end,
	},
}, {
	-- Small performance tweaks for lazy.nvim
	rocks = {
		enabled = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
				"gzip",
				"tarPlugin",
				"zipPlugin",
				"matchit",
				"matchparen",
			},
		},
	},
})

-- Enable Lua module loader for faster startup (Neovim 0.9+)
if vim.loader and vim.loader.enable then
	vim.loader.enable()
end
