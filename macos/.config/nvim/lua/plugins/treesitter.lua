return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		opts = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		-- For `nvim-treesitter` users.
		priority = 49,

		-- For blink.cmp's completion
		-- source
		-- dependencies = {
		--     "saghen/blink.cmp"
		-- },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"cuda",
				"gitignore",
				"html",
				"jinja2",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"ninja",
				"proto",
				"python",
				"rust",
				"tmux",
				"yaml",
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
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "htmldjango" },
				},
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					move = {
						enable = true,
						set_jumps = true, -- jumplist에 기록

						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]l"] = "@loop.outer",
							["]i"] = "@conditional.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[l"] = "@loop.outer",
							["[i"] = "@conditional.outer",
						},
					},
				},
			})
		end,
	},
}
