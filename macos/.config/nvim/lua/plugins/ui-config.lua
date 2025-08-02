return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    -- -@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      local harpoon = require("harpoon")
      require("telescope").load_extension("harpoon")
      harpoon:setup()
      -- 파일 추가
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      -- 빠른 메뉴 (Harpoon UI)
      vim.keymap.set("n", "<C-m>", function()
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

      -- Telescope 연동 보기
      vim.keymap.set("n", "<leader>hf", "<cmd>Telescope harpoon marks<cr>")
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "Djancyp/better-comments.nvim",
    config = function()
      require("better-comment").Setup({
        tags = {
          {
            name = "TODO",
            fg = "white",
            bg = "#0a7aca",
            bold = true,
            virtual_text = "",
          },
          {
            name = "FIX",
            fg = "white",
            bg = "#f44747",
            bold = true,
            virtual_text = "",
          },
          {
            name = "WARNING",
            fg = "#FFA500",
            bg = "",
            bold = false,
            virtual_text = "",
          },
          {
            name = "ERROR",
            fg = "#f44747",
            bg = "",
            bold = true,
            virtual_text = " ",
          },
          {
            name = "INFO",
            fg = "#3498DB",
            bg = "",
            bold = true,
            virtual_text = " ",
          },
          {
            name = "REMARK",
            fg = "#98C379",
            bg = "",
            bold = true,
            virtual_text = " ",
          },
        },
      })
    end,
  },
  -- {
  -- 	"folke/todo-comments.nvim",
  -- },
}
