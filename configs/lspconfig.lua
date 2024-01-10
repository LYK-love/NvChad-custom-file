local base = require("plugins.configs.lspconfig")
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "pyright" }

for _, lsp in ipairs(servers) do
	-- Define the default configuration
	local config = {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	lspconfig[lsp].setup(config)
end

lspconfig.clangd.setup({
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	cmd = {
		"clangd",

		-- Fix bug "Multiple different client offset_encodings detected"
		-- Link: https://www.reddit.com/r/neovim/comments/12qbcua/comment/jgpqxsp/?utm_source=share&utm_medium=web2x&context=3
		"--offset-encoding=utf-16",
	},
})

--
-- lspconfig.pyright.setup { blabla}
