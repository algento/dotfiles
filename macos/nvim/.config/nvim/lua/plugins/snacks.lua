return {
  {
    "folke/snacks.nvim",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    priority = 1000,
    lazy = false,
    config = function(_, opts)
      local status, snacks_util = pcall(require, "snacks.util")
      if status and snacks_util and snacks_util.blend then
        local original_blend = snacks_util.blend
        snacks_util.blend = function(fg, bg, alpha)
          if not fg or not bg or type(fg) ~= "string" or type(bg) ~= "string" or fg:sub(1, 1) ~= "#" or bg:sub(1, 1) ~= "#" then
            return fg or bg or "#000000"
          end
          return original_blend(fg, bg, alpha)
        end
      end
      require("snacks").setup(opts)
    end,
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
      terminal = {
        enabled = true,
        win = {
          style = "float",
          width = 0.8,
          height = 0.8,
          border = "rounded",
        },
      },
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

    },
  },
}
