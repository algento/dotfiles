return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
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
