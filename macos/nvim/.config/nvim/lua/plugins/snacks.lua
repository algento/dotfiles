return {
  {
    "folke/snacks.nvim",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
"                                                     ",
"  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
"  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
"  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
"  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
"  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
"  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
"                                                     ",
         ]],
        },
      },
      indent = {
        enabled = true,
        filter = function(buf)
          return vim.bo[buf].filetype ~= "markdown"
        end,
      },
      input = { enabled = true },
      git = { enabled = true },
      explorer = { enabled = false },
      picker = {
        enabled = false,
        -- layout = {
        --   layout = {
        --     width = 0.25,
        --   },
        -- },
      },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = true,
        img_dirs = {
          "/Users/sejong/Github/sejong-wiki/resources/figs",
        },
        -- max_width = 0,
        -- max_height = 0,
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
          },
        },
        doc = {
          enabled = true,
          inline = false,
          float = true,
        },
      },
    },
    keys = {
      {
        "<C-n>",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
      },
      -- Scratch Buffer
      {
        "<leader>sf",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>S",
        function()
          Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
      },
      -- lazygit
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      --[[ {
        "<leader>gl",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Log (cwd)",
      }, ]]
      -- Snack picker (diable, usd fzf-lua)
      --[[ {
        "<C-p>",
        function()
          Snacks.picker.pick("files")
        end,
        desc = "Find Files",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep Files",
      }, ]]
    },
  },
}
