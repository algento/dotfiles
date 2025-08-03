return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    term_colors = true,
    transparent_background = true, -- disables setting the background color.j
    fzf = true,
  },
  config = function()
    vim.cmd.colorscheme("catppuccin-mocha")
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}
