local M = {}

M.treesitter = {
	ensure_installed = {
		"vim",
		"lua",
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
		"c",
		"markdown",
		"markdown_inline",
		-- Custumization:
		"python",
		"java",
		"cpp",
		"rust",
		"go",
		"json",
	},
	indent = {
		enable = true,
		-- disable = {
		--   "python"
		-- },
	},
}

M.mason = {
	ensure_installed = {
		-- lua stuff
		"lua-language-server",
		"stylua",

		-- web dev stuff
		"css-lsp",
		"html-lsp",
		"typescript-language-server",
		"deno",
		"prettier",

		-- c/cpp stuff
		"clangd",
		"clang-format",
		"codelldb",

		-----------------------------------------------
		-- python stuff
		"pyright",
		-- linters for python
		"mypy", -- A static type checker for Python. See https://github.com/python/mypy
		"ruff", -- An extremely fast Python linter and code formatter. See https://github.com/astral-sh/ruff
		-- formatter for python
		"black", -- Black is the uncompromising Python code formatter. See https://github.com/psf/black

		-- Debugger for python
		"debugpy",

		-----------------------------------------------
		-- rust stuff
		"rust-analyzer",

		-----------------------------------------------
	},
}

-- git support in nvimtree
M.nvimtree = {
	git = {
		enable = true,
	},

	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
			},
		},
	},
}

return M
