-- ~/.config/nvim/lua/config/format.lua
-- Central formatting configuration using conform.nvim.

local conform = require("conform")

conform.setup({
	-- Map filetypes to one or more external formatters.
	-- These formatter names assume you install them via Mason or globally.
	formatters_by_ft = {
		python = { "ruff_format" },
		lua = { "stylua" },
		javascript = { "prettierd", "eslint_d" },
		typescript = { "prettierd", "eslint_d" },
		javascriptreact = { "prettierd", "eslint_d" },
		typescriptreact = { "prettierd", "eslint_d" },
		json = { "prettierd" },
		markdown = { "prettierd" },
		toml = { "taplo" },
		yaml = { "prettierd" },
		dockerfile = {},
		sql = { "sql_formatter" },
	},
	-- If no external formatter is found, fall back to LSP formatting.
	notify_on_error = true,
})

-- Use <leader>f to format via conform for both normal and visual mode.
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({
		async = true,
		lsp_fallback = true,
	})
end, { desc = "Format buffer via conform" })

-- Optional: format on save for selected filetypes.
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.py", "*.lua", "*.js", "*.jsx", "*.ts", "*.tsx", "*.toml", "*.json", "*.md" },
	callback = function(args)
		conform.format({
			bufnr = args.buf,
			async = false,
			lsp_fallback = true,
		})
	end,
})
