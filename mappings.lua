---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["<leader>i"] = {
			function()
				require("nvterm.terminal").new("float")
			end,
			"New floating term",
		},
	},
	v = {
		[">"] = { ">gv", "indent" },
	},
}

-- more keybinds!

-- For debugging
M.dap = {
	plugin = true,
	n = {
		["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
		["<leader>dr"] = {
			"<cmd> DapContinue <CR>",
			"Start or continue the debugger",
		},
		["<leader>dus"] = {
			function()
				local widgets = require("dap.ui.widgets")
				local sidebar = widgets.sidebar(widgets.scopes)
				sidebar.open()
			end,
			"Open debugging sidebar",
		},
	},
}

M.dap_python = {
	plugin = true,
	n = {
		["<leader>dpr"] = {
			function()
				require("dap-python").test_method()
			end,
		},
	},
}

-- For rust
M.crates = {
	plugin = true,
	n = {
		["<leader>rcu"] = {
			function()
				require("crates").upgrade_all_crates()
			end,
			"update crates",
		},
	},
}

-- Projects
M.projects = {
	n = {
		["<leader>pm"] = { "<cmd> ProjectMgr<CR>", "Open Projects" },
	},
}

-- binding for Markdown Preview
M.mdpreview = {
	n = {
		["<leader>mp"] = { "<cmd> MarkdownPreview<CR>", "Open Preview" },
		["<leader>mc"] = { "<cmd> MarkdownPreviewStop<CR>", "Close Preview" },
	},
}
return M
