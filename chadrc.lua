---@type ChadrcConfig
local M = {}

local core = require("custom.utils.core")

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "gruvbox",
	theme_toggle = { "gruvbox", "one_light" },

	hl_override = highlights.override,
	hl_add = highlights.add,

	-- nvdash (dashboard)
	nvdash = core.nvdash,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

-- M.ui.nvdash.load_on_startup = true
return M
