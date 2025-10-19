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
      indent = { enabled = true },
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
        -- img_dirs = {
        --   vim.fn.expand("~/Github/docs/obsidian-sync/Attachments"),
        -- },
        enabled = true,
        max_width = 0,
        max_height = 0,
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
          },
        },
      },
    },
    keys = {
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
      -- {
      --   "<leader>gl",
      --   function()
      --     Snacks.lazygit.log_file()
      --   end,
      --   desc = "Lazygit Log (cwd)",
      -- },
      {
        "<leader>lg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      -- {
      --   "<C-p>",
      --   function()
      --     Snacks.picker.pick("files")
      --   end,
      --   desc = "Find Files",
      -- },
      -- {
      --   "<leader><leader>",
      --   function()
      --     Snacks.picker.recent()
      --   end,
      --   desc = "Recent Files",
      -- },
      -- {
      --   "<leader>fb",
      --   function()
      --     Snacks.picker.buffers()
      --   end,
      --   desc = "Buffers",
      -- },
      -- {
      --   "<leader>fg",
      --   function()
      --     Snacks.picker.grep()
      --   end,
      --   desc = "Grep Files",
      -- },
      {
        "<C-n>",
        function()
          Snacks.explorer()
        end,
        desc = "Explorer",
      },
    },
  },
}
