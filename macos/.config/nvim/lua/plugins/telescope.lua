return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- config = function()
    --   local builtin = require("telescope.builtin")
    --   vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
    --   vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
    --   vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
    --   vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
    -- end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      -- add "ui-select" extension to "telescope"
      require("telescope").setup({
        pickers = {
          live_grep = {
            file_ignore_patterns = { "node_modules", ".git", ".venv" },
            additional_args = function(_)
              return { "--hidden" }
            end,
          },
          find_files = {
            file_ignore_patterns = { "node_modules", ".git", ".venv" },
            hidden = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
        },
      })
      -- load extension for "telescope"
      require("telescope").load_extension("ui-select")
    end,
  },
}
