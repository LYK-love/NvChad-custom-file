local overrides = require("custom.configs.overrides")

local cmp = require("cmp")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- All NvChad plugins are lazy-loaded by default
	-- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
	-- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
	-- {
	--   "mg979/vim-visual-multi",
	--   lazy = false,
	-- }
	--
	-- ChatGPT
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		config = function()
			require("chatgpt").setup()
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},

	--------------------------------------------------------------------------------
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	{
		"mfussenegger/nvim-dap",
		config = function(_, opts)
			require("core.utils").load_mappings("dap")
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = false,
		config = function(_, opts)
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- For python
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function(_, opts)
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
			require("core.utils").load_mappings("dap_python")
		end,
	},

	-- C++ adaptor
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {},
		},
	},

	-----------------------------------------------------------
	--rust
	--rust formatter. It doesn't need to config in the null-ls.
	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1 -- format on saving
		end,
	},

	--Lots of useful features
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		dependencies = "neovim/nvim-lspconfig",
		opts = function()
			return require("custom.configs.rust-tools")
		end,
		config = function(_, opts)
			require("rust-tools").setup(opts)
		end,
	},

	-- Jump into crate's link
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			require("cmp").setup.buffer({
				sources = { { name = "crates" } },
			})
			crates.show()
			require("core.utils").load_mappings("crates")
		end,
	},

	-- Heavily modified to support CMD completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Commandline completions
			{
				"hrsh7th/cmp-cmdline",
			},
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
			},
		},

		event = { "InsertEnter", "CmdlineEnter" },

		opts = function()
			local M = require("plugins.configs.cmp")
			cmp.setup.cmdline(":", { -- override default cmp behavior
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "cmdline" },
				},
			})

			M.completion.completeopt = "menu,menuone,noselect"
			M.mapping["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			})

			M.mapping["<C-j>"] = cmp.mapping(function(_fallback)
				cmp.mapping.abort()
				require("copilot.suggestion").accept_line()
			end, {
				"i",
				"s",
			})

			table.insert(M.sources, { name = "crates" })
			return M
		end,
	},
	--
	-- Peek bufffer at Lines when inputing CMD
	{
		"nacro90/numb.nvim",
		event = "CmdlineEnter",
		config = true,
	},
	-- Folds code block
	{
		"kevinhwang91/nvim-ufo",
		event = "VeryLazy",
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
			vim.o.foldmethod = "indent"
		end,
		opts = {
			provider_selector = function(_, _, _)
				return { "treesitter", "indent" }
			end,
		},
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						relculright = true,
						segments = {
							{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
							{ text = { "%s" }, click = "v:lua.ScSa" },
						},
					})
				end,
			},
		},
	},
	-- Workspaces
	{
		"natecraddock/workspaces.nvim",
		cmd = { "WorkspacesList", "WorkspacesAdd", "WorkspacesOpen", "WorkspacesRemove" },
		config = function()
			require("workspaces").setup({
				hooks = {
					open = "Telescope find_files",
				},
			})
		end,
	},
	--Project Manager
	{
		"charludo/projectmgr.nvim",
		lazy = false, -- important!
		config = function()
			require("projectmgr").setup({
				autogit = {
					enabled = true,
					command = "git pull --ff-only > .git/fastforward.log 2>&1",
				},
				session = { enabled = true, file = ".git/Session.vim" }, --- the project need to be a git repo, otherwise it doesn't have a '.git' dir.
			})
		end,
	},

	-- Preview Markdown
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
		lazy = false,
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_theme = "dark"
		end,
	},

	-- Providing a simple, unified, single tabpage interface that lets you easily review all changed files for any git rev.
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},

	-- Improve UI
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = require("custom.configs.dressing"),
	},
	{
		"m4xshen/autoclose.nvim",
		event = "BufEnter",
		config = function()
			require("autoclose").setup()
		end,
	},

	-- Fluent scroll
	{
		"karb94/neoscroll.nvim",
		keys = { "<C-d>", "<C-u>" },
		config = function()
			require("neoscroll").setup({ mappings = {
				"<C-u>",
				"<C-d>",
			} })
		end,
	},

	----------------------------------------- enhance plugins ------------------------------------------
	-- Save even when quit with `q!`
	{
		"okuuva/auto-save.nvim",
		event = { "InsertLeave", "TextChanged" },
		config = function()
			require("custom.configs.autosave")
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = "CursorHold",
		config = function()
			require("illuminate").configure({
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				under_cursor = false,
			})
		end,
	},

	--For splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
	{
		"Wansmer/treesj",
		cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = true,
			})
		end,
	},

	-- Some LSP servers are terribly inefficient at memory management and can easily take up gigabytes of RAM MBs if left unattended (just like VS Code huh?!). This plugin prevents excessive memory usage by stopping and restarting LSP servers automatically upon gaining or loosing window focus, keeping neovim fast.
	{
		"hinell/lsp-timeout.nvim",
		event = "LspAttach",
		config = function()
			vim.g["lsp-timeout-config"] = {
				-- When focus is lost
				-- wait 5 minutes before stopping all LSP servers
				stopTimeout = 1000 * 60 * 5,
				startTimeout = 1000 * 10,
				silent = true,
			}
		end,
	},

	-- With debugprint, you can insert appropriate 'print' statements relevant to the language you're editing. These statements include reference information for quick output navigation and the ability to output variable values.
	{
		"andrewferrier/debugprint.nvim",
		keys = { "<leader><leader>p" },
		config = function()
			require("debugprint").setup({
				create_keymaps = false,
				create_commands = false,
			})
		end,
	},

	--- Providing alternating syntax highlighting (“rainbow parentheses”) for Neovim
	{
		"hiphish/rainbow-delimiters.nvim",
		event = "BufReadPost",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
	},

	--Cutlass overrides the delete operations to actually just delete and not affect the current yank.
	{
		"gbprod/cutlass.nvim",
		event = "BufReadPost",
		opts = {
			cut_key = "x",
			override_del = true,
			exclude = {},
			registers = {
				select = "_",
				delete = "_",
				change = "_",
			},
		},
	},

	--Send buffers into early retirement by automatically closing them after x minutes of inactivity.
	{
		"chrisgrieser/nvim-early-retirement",
		event = "VeryLazy",
		opts = {
			retirementAgeMins = 5,
			notificationOnAutoClose = false,
		},
	},

	----------------------------------------- ui plugins ------------------------------------------
	-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				hover = {
					enabled = false,
					silent = false, -- set to true to not show a message if hover is not available
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
				signature = {
					enabled = false,
					auto_open = {
						enabled = true,
						trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
						luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
						throttle = 50, -- Debounce lsp signature help request by 50ms
					},
					view = nil, -- when nil, use defaults from documentation
					---@type NoiceViewOptions
					opts = {}, -- merged with defaults from documentation
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
	},
	-- Save breakpoints even after the buffer is closed
	{
		"Weissle/persistent-breakpoints.nvim",
		ft = "go",
		config = function()
			require("persistent-breakpoints").setup({
				load_breakpoints_event = { "BufReadPost" },
			})
		end,
	},

	--Change the color of your cursor's line number based on the current Vim mode.
	{
		"mawkler/modicator.nvim",
		event = "ModeChanged",
		init = function()
			vim.o.cursorline = true
			vim.o.number = true
			vim.o.termguicolors = true
		end,
		opts = {
			show_warnings = false,
			highlights = {
				defaults = { bold = true },
			},
		},
	},

	--Display a character as the colorcolumn.
	{
		"lukas-reineke/virt-column.nvim",
		config = function()
			require("virt-column").setup({
				char = "┃",
			})
		end,
	},

	-- A curl wrapper
	{
		"rest-nvim/rest.nvim",
		ft = { "http" },
		config = function()
			require("rest-nvim").setup({
				result_split_horizontal = true,
				encode_url = true, -- Encode URL before making request
				result = {
					show_url = false,
					show_http_info = true,
					show_headers = false,
					formatters = {
						json = function(body)
              -- stylua: ignore
              return vim.fn.system { "biome", "format", "--stdin", "--stdin-file-path", "foo.json", body }
						end,
						-- prettier already needed since it's the only proper yaml formatter
						html = function(body)
							return vim.fn.system({ "prettier", "--parser=html", body })
						end,
					},
				},
			})
		end,
	},

	-- Highlight, List and Search Todo comments in your projects
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoLocList", "TodoQuickFix", "TodoTelescope" },
		opts = require("custom.configs.todo-comments"),
	},

	-- An enhanced visual diagnostic display for Neovim
	{
		"chikko80/error-lens.nvim",
		ft = "go",
		config = true,
	},

	----A pretty list for showing diagnostics, references, telescope results, quickfix and location lists.
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		config = function()
			require("custom.configs.trouble")
			dofile(vim.g.base46_cache .. "trouble")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
	},
	{
		"BrunoKrugel/lazydocker.nvim",
		cmd = "LazyDocker",
	},
	{
		"AckslD/muren.nvim",
		cmd = "MurenToggle",
		config = true,
	},
	{
		"f-person/git-blame.nvim",
		cmd = "GitBlameToggle",
	},

	---blame.nvim is a fugitive.vim style git blame visualizer for Neovim.
	{
		"FabijanZulj/blame.nvim",
		cmd = "ToggleBlame",
	},
	{
		"akinsho/git-conflict.nvim",
		ft = "gitcommit",
		config = function()
			require("git-conflict").setup()
		end,
	},

	---Start your search from a more comfortable place, say the upper right corner?
	{
		"VonHeikemen/searchbox.nvim",
		cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
		config = true,
	},

	---Enhanced matchparen.vim plugin for Neovim to highlight the outer pair.
	{
		"utilyre/sentiment.nvim",
		event = "LspAttach",
		opts = {},
		init = function()
			vim.g.loaded_matchparen = 1
		end,
	},

	--A simple plugin that highlights whole lines in linewise visual mode (V)
	{
		"0xAdk/full_visual_line.nvim",
		keys = { "V" },
		config = function()
			require("full_visual_line").setup({})
		end,
	},

	-- to persist and toggle multiple terminals during an editing session
	{
		"akinsho/toggleterm.nvim",
		keys = { [[<C-\>]] },
		cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 0.25 * vim.api.nvim_win_get_height(0)
				elseif term.direction == "vertical" then
					return 0.25 * vim.api.nvim_win_get_width(0)
				elseif term.direction == "float" then
					return 85
				end
			end,
			open_mapping = [[<C-\>]],
			hide_numbers = true,
			shade_terminals = false,
			insert_mappings = true,
			start_in_insert = true,
			persist_size = true,
			direction = "horizontal",
			close_on_exit = true,
			shell = vim.o.shell,
			autochdir = true,
			highlights = {
				NormalFloat = {
					link = "Normal",
				},
				FloatBorder = {
					link = "FloatBorder",
				},
			},
			float_opts = {
				border = "rounded",
				winblend = 0,
			},
		},
	},

	--The gh-actions plugin for Neovim allows developers to easily manage and dispatch their GitHub Actions workflow runs directly from within the editor.
	{
		"topaxi/gh-actions.nvim",
		cmd = "GhActions",
		opts = {},
	},

	----------------------------------------- language plugins ------------------------------------------
	--Code refactoring
	{
		"ThePrimeagen/refactoring.nvim",
		event = "BufRead",
		config = function()
			require("custom.configs.refactoring")
		end,
	}, ----------------------------------------- completions plugins ------------------------------------------
}

return plugins
