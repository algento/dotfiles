return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		--"jay-babu/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "json", "yaml", "markdown" },
				}),
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.mypy.with({
					extra_args = function()
						local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
						return { "--python-executable", virtual .. "/bin/python3" }
					end,
				}),
				-- null_ls.builtins.diagnostics.ruff,
				-- null_ls.builtins.formatting.ruff,
				-- null_ls.builtins.formatting.ruff_format,
				require("none-ls.diagnostics.ruff"),
				require("none-ls.formatting.ruff").with({
					extra_args = { "--extend-select", "I" },
				}),
				require("none-ls.formatting.ruff_format"),
			},
			-- none-ls/formatting on save
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
							--https://github.com/nvimtools/none-ls.nvim/wiki/Formatting-on-save
						end,
					})
				end
			end,
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
