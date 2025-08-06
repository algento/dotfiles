return {

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      -- check_ts = true, --enable treesitter
      -- ts_config = {
      --   lua = { "string" }, --don't add pairs in lua string treesitter nodes
      -- },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },
  {
    "tpope/vim-sleuth",
    -- No further initialization needed, as this is a real "vim" not a lua
    -- plugin.
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    -- dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      -- require("telescope").load_extension("harpoon")
      harpoon:setup()
      -- 파일 추가
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      -- 빠른 메뉴 (Harpoon UI)
      vim.keymap.set("n", "<leader>m", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- 파일 간 빠른 이동
      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end)
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end)
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end)
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end)
    end,
  },
}
