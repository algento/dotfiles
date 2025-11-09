return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        message = {
          enabled = true,
          view = "mini",
        },
      },
    },
    keys = {
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
          -- require("noice").cmd("all")
        end,
        desc = "[N]oice [H]istory",
        mode = "n",
      },
    },
    dependencies = {
      -- "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
    },
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   main = "ibl",
  --   ---@module "ibl"
  --   ---@type ibl.config
  --   opts = {},
  -- },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 0, -- which-key v3 기준 옵션 (v2는 triggers/timeoutlen로 조절)
      triggers = {
        { "<leader>", mode = { "n", "v", "o" } },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
