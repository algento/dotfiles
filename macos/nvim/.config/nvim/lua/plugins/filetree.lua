return {
  -- Oil
  {
    "stevearc/oil.nvim",
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        -- oil 버퍼에서 사용될 keymap 설정
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<C-]>"] = "actions.select_split",
        ["<Esc>"] = { "actions.close", mode = "n" },
      },
      columns = {
        "icon",
      },
    },
    lazy = false,
    config = function(_, opts)
      local oil = require("oil")
      oil.setup(opts)
      vim.keymap.set("n", "-", oil.toggle_float, {})
      -- oil 버퍼에서만 적용되는 매핑 설정 (nvim_create_autocmd 사용 권장)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          -- vim.keymap.set("n", "C", function()
          --   require("oil").open_new_file()
          -- end, { desc = "Create file/directory" })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "OilEnter",
        callback = vim.schedule_wrap(function(args)
          if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
            oil.open_preview()
          end
        end),
      })
    end,
  },
}
