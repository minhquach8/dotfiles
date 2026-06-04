-- ~/.config/nvim/lua/config/lsp.lua
-- LSP setup (Neovim 0.11 API) + language-specific config.

------------------------------------------------------------
-- Shared on_attach for all language servers
------------------------------------------------------------
local on_attach = function(_, bufnr)
	local function bmap(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	-- Go to / info
	bmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
	bmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	bmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	bmap("n", "gr", vim.lsp.buf.references, "References")
	bmap("n", "K", vim.lsp.buf.hover, "Hover")

	-- Refactor / actions
	bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	bmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

	-- Diagnostics
	bmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	bmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
	bmap("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
end

------------------------------------------------------------
-- Capabilities (nvim-cmp integration)
------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

------------------------------------------------------------
-- Default config for all LSP servers
------------------------------------------------------------
vim.lsp.config("*", {
	on_attach = on_attach,
	capabilities = capabilities,
})

------------------------------------------------------------
-- Enable main servers
------------------------------------------------------------
vim.lsp.enable({
	"pyright", -- Python type checking
	"lua_ls", -- Lua / Neovim config
	"bashls", -- Bash
	"ruff", -- Python lint/format via Ruff
	"taplo", -- TOML
	"ts_ls", -- TypeScript / JavaScript
	"eslint", -- ESLint for JS/TS
	"yamlls", -- YAML
	"dockerls", -- Dockerfile
	"sqlls", -- SQL
})

------------------------------------------------------------
-- Ruff LSP: Python lint + optional format
------------------------------------------------------------
vim.lsp.config("ruff", {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		local rmap = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		-- Optional: dedicated Ruff format mapping (still uses LSP)
		rmap("n", "<leader>rf", function()
			vim.lsp.buf.format({ async = true })
		end, "Ruff format file")
	end,
	capabilities = capabilities,
})

------------------------------------------------------------
-- TypeScript / JavaScript (ts_ls)
------------------------------------------------------------
vim.lsp.config("ts_ls", {
	on_attach = function(client, bufnr)
		-- Let external tools (Prettier, ESLint, Conform) handle formatting.
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false

		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
})

------------------------------------------------------------
-- ESLint LSP: lint + fixAll for JS/TS
------------------------------------------------------------
vim.lsp.config("eslint", {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)

		local emap = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end

		-- Manually trigger "fix all" from ESLint
		emap("n", "<leader>ef", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.fixAll.eslint" },
					diagnostics = {},
				},
			})
		end, "ESLint fix all")
	end,
	capabilities = capabilities,
})

-- Optional: auto-run ESLint "fixAll" on save for JS/TS files.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
	callback = function()
		pcall(function()
			vim.lsp.buf.code_action({
				apply = true,
				context = {
					only = { "source.fixAll.eslint" },
					diagnostics = {},
				},
			})
		end)
	end,
})
