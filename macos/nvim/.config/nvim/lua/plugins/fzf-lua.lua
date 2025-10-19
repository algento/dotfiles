return {
  "ibhagwan/fzf-lua",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    winopts = {
      preview = {
        layout = "vertical",
      },
    },
    files = {
      fd_opts = [[--color=never --hidden --follow --type f --exclude .git --exclude .obsidian --exclude Attachments]],
    },
    grep = {
      rg_opts = [[--color=never --hidden --follow --line-number --column --smart-case -g '!.git' -g '!.obsidian/**' -g '!**/Attachments/**']],
    },
    keymap = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "[F]ind [F]iles in project directory",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "[F]ind by [G]repping in project directory",
    },
    -- for convenient check of neovim configuration
    {
      "<leader>fc",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind in neovim [C]onfiguration",
    },
    -- for easily checking neovim help functions
    {
      "<leader>fh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "[F]ind [H]elp",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "[F]ind [K]eymaps",
    },
    -- for using fzf-lua's useful builtin function with ui
    {
      "<leader>fb",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "[F]ind [B]uiltin FZF",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "[F]ind current [W]ord",
    },
    {
      "<leader>fW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "[F]ind current [W]ORD",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "[F]ind [D]iagnostics",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").resume()
      end,
      desc = "[F]ind [R]esume",
    },
    {
      "<leader>fl",
      function()
        require("fzf-lua").grep({
          prompt = "Find+Replace > ",
          actions = {
            ["ctrl-q"] = function(selected)
              vim.cmd("copen")
              print("→ Send to Quickfix. do `:cfdo %s/old/new/ge | update`")
            end,
          },
        })
      end,
      desc = "[F]ind replace [L]ist",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "[F]ind [O]ld Files",
    },
    -- easy switching between files in buffers
    {
      "<leader><leader>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[,] Find existing buffers",
    },
    {
      "<leader>/",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "[/] Live grep the current buffer",
    },
  },
}
