return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"c",
			"cpp",
			"python",
			"ninja",
			"bash",
			"markdown",
			"html",
			"cmake",
		},
	},
	config = function(_, opts)
		local config = require("nvim-treesitter.configs")
		config.setup({
			--ensure_installed = {
			--  "lua",
			--},
			opts = opts,
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
