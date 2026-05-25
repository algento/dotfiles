return {
  -- auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      -- check_ts = true, --enable treesitter
      -- ts_config = {
      --   lua = { "string" }, --don't add pairs in lua string treesitter nodes
      -- },
      -- map_space = false,
    },
  },
  -- auto tags
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  -- Code Folding
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
  -- editorconfig support?
  {
    "tpope/vim-sleuth",
    -- No further initialization needed, as this is a real "vim" not a lua
    -- plugin.
  },
  -- Show buffers as a vs-code like taps
  {
    "akinsho/bufferline.nvim",
    version = "*",
    -- dependencies = "nvim-tree/nvim-web-devicons"
    dependencies = "nvim-mini/mini.icons",
    opts = {},
  },
  -- High-speed movement between buffers
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
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "[H]arpoon [A]dd" })
      -- 빠른 메뉴 (Harpoon UI)
      vim.keymap.set("n", "<leader>hm", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "[H]arpoon [M]enu" })

      -- 파일 간 빠른 이동
      vim.keymap.set("n", "<leader>h1", function()
        harpoon:list():select(1)
      end, { desc = "[H]arpoon [1]" })
      vim.keymap.set("n", "<leader>h2", function()
        harpoon:list():select(2)
      end, { desc = "[H]arpoon [2]" })
      vim.keymap.set("n", "<leader>h3", function()
        harpoon:list():select(3)
      end, { desc = "[H]arpoon [3]" })
      vim.keymap.set("n", "<leader>h4", function()
        harpoon:list():select(4)
      end, { desc = "[H]arpoon [4]" })
    end,
  },

  -- Global Search and Replace
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and ("*." .. ext) or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace with Grug-far",
      },
    },
    opts = { headerMaxWidth = 80 },
  },

  --[[   {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  }, ]]

  --[[ {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
  }, ]]
}
