return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup", -- 중앙 팝업 명령줄
      },
      messages = {
        enabled = true,
        view = "mini", -- 일반 메시지는 하단 mini 뷰
        view_error = "notify",
        view_warn = "notify",
      },
      popupmenu = {
        enabled = true,
        backend = "nui", -- modern 스타일 팝업 메뉴
      },
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        progress = { enabled = true, view = "mini" },
        message = {
          enabled = true,
          view = "mini",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false, -- 검색창을 하단이 아닌 중앙 팝업으로
        command_palette = true, -- 커맨드 라인을 팝업으로
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
      },
    },
    keys = {
      {
        "<leader>nh",
        function()
          require("noice").cmd("history")
        end,
        desc = "[N]oice [H]istory",
        mode = "n",
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
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
