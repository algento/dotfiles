return {

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
