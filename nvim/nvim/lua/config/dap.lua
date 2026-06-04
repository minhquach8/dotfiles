-- ~/.config/nvim/lua/config/dap.lua
-- Core configuration for nvim-dap and dap-ui.
-- Provides:
--   - Common keymaps (F5, F10, F11, F12, F9, etc.).
--   - UI auto open/close.
--   - Basic configurations for Python, JavaScript/TypeScript (Node),
--     and C/C++ using adapters installed by mason-nvim-dap.

local dap = require("dap")
local dapui = require("dapui")

------------------------------------------------------------
-- 1. dap-ui setup
------------------------------------------------------------
dapui.setup({
	-- Use fairly minimal default layout; you can tune later if you like.
	layouts = {
		{
			elements = {
				"scopes",
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "right",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10,
			position = "bottom",
		},
	},
	controls = {
		enabled = true,
		element = "repl",
	},
})

-- Automatically open/close dap-ui when debug starts/stops.
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

------------------------------------------------------------
-- 2. Keymaps for debugging
------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Core debug flow
map("n", "<F5>", dap.continue, vim.tbl_extend("force", opts, { desc = "DAP continue/start" }))
map("n", "<F10>", dap.step_over, vim.tbl_extend("force", opts, { desc = "DAP step over" }))
map("n", "<F11>", dap.step_into, vim.tbl_extend("force", opts, { desc = "DAP step into" }))
map("n", "<F12>", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP step out" }))

-- Breakpoints
map("n", "<F9>", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "DAP toggle breakpoint" }))
map("n", "<leader>db", dap.toggle_breakpoint, vim.tbl_extend("force", opts, { desc = "DAP toggle breakpoint" }))
map("n", "<leader>dB", function()
	vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
		if cond and cond ~= "" then
			dap.set_breakpoint(cond)
		end
	end)
end, vim.tbl_extend("force", opts, { desc = "DAP conditional breakpoint" }))

-- Debug session controls
map("n", "<leader>dc", dap.continue, vim.tbl_extend("force", opts, { desc = "DAP continue" }))
map("n", "<leader>do", dap.step_over, vim.tbl_extend("force", opts, { desc = "DAP step over" }))
map("n", "<leader>di", dap.step_into, vim.tbl_extend("force", opts, { desc = "DAP step into" }))
map("n", "<leader>dO", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP step out" }))
map("n", "<leader>dr", dap.repl.open, vim.tbl_extend("force", opts, { desc = "DAP open REPL" }))
map("n", "<leader>dq", function()
	dap.terminate()
	dapui.close()
end, vim.tbl_extend("force", opts, { desc = "DAP terminate" }))

-- Inspect values (when stopped at breakpoint)
map("n", "<leader>dh", function()
	require("dap.ui.widgets").hover()
end, vim.tbl_extend("force", opts, { desc = "DAP hover value" }))

------------------------------------------------------------
-- 3. Language specific configurations
--    Adapters themselves are installed and wired by mason-nvim-dap.
------------------------------------------------------------

------------------------------------------------------------
-- 3.1 Python (debugpy)
------------------------------------------------------------
-- mason-nvim-dap registers the "python" adapter; here we only define configurations.
dap.configurations.python = {
	{
		type = "python",
		request = "launch",
		name = "Python: Launch current file",
		program = "${file}",
		console = "integratedTerminal",
	},
}

------------------------------------------------------------
-- 3.2 JavaScript / TypeScript (Node, adapter = node2)
------------------------------------------------------------
local node_launch = {
	name = "Node: Launch current file",
	type = "node2",
	request = "launch",
	program = "${file}",
	cwd = vim.fn.getcwd(),
	sourceMaps = true,
	protocol = "inspector",
	console = "integratedTerminal",
}

dap.configurations.javascript = {
	node_launch,
}

dap.configurations.typescript = {
	node_launch,
}

-- Optionally for React / TSX, you can reuse this:
dap.configurations.javascriptreact = {
	node_launch,
}
dap.configurations.typescriptreact = {
	node_launch,
}

------------------------------------------------------------
-- 3.3 C / C++ (cppdbg - vscode-cpptools)
------------------------------------------------------------
local cpp_launch = {
	name = "C/C++: Launch executable",
	type = "cppdbg",
	request = "launch",
	program = function()
		-- Ask user for compiled binary path, defaulting to current directory.
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end,
	cwd = "${workspaceFolder}",
	stopAtEntry = false,
	setupCommands = {
		{
			text = "-enable-pretty-printing",
			description = "Enable pretty printing (gdb/lldb)",
			ignoreFailures = false,
		},
	},
}

dap.configurations.cpp = {
	cpp_launch,
}

dap.configurations.c = {
	cpp_launch,
}

-- If you ever use Rust:
dap.configurations.rust = {
	cpp_launch,
}
