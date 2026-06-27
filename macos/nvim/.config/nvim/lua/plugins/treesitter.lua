return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local config = require("nvim-treesitter.config")
      config.setup({
        ensure_installed = {
          "bash",
          "cmake",
          "comment",
          "cpp",
          "css",
          "csv",
          "cuda",
          "dockerfile",
          "doxygen",
          "git_config",
          "git_rebase",
          "gitcommit",
          "gitignore",
          "glsl",
          "go",
          "html",
          "htmldjango",
          "java",
          "javascript",
          "jinja",
          "jinja_inline",
          "json",
          "jsonc",
          "latex",
          "markdown",
          "markdown_inline",
          "ninja",
          "proto",
          "python",
          "query",
          "rust",
          "typescript",
          "tmux",
          "yaml",
        },
        auto_install = true,
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        highlight = {
          enable = true,
          disable = { "text", "markdown" },
          additional_vim_regex_highlighting = { "markdown" },
        },
        indent = { enable = true },
        playground = {
          enable = false,
        },
      })
      -- use bash parser for zsh files
      vim.treesitter.language.register("bash", "zsh")

      -- 로컬 스크립트를 변경하지 않는 완전한 설정 레벨 해법:
      -- lazy.nvim의 자동 소싱(plugin/ 스크립트 실행)을 피하기 위해 플러그인은 비활성화하되,
      -- 쿼리 파일들을 사용하기 위해 rtp에 경로만 직접 마운트합니다.
      local textobjects_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter-textobjects"
      if vim.fn.isdirectory(textobjects_path) == 1 then
        vim.opt.rtp:append(textobjects_path)
      end

      -- textobjects 설정도 nvim-treesitter가 완전히 로드된 후 setup합니다.
      require("nvim-treesitter.config").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
              ["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
              ["l="] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
              ["r="] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },

              ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
              ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },

              ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
              ["=i"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },

              ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
              ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

              ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
              ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },

              ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
              ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },

              ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>na"] = "@parameter.inner",
              ["<leader>nm"] = "@function.outer",
            },
            swap_previous = {
              ["<leader>pa"] = "@parameter.inner",
              ["<leader>pm"] = "@function.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = { query = "@call.outer", desc = "Next function call start" },
              ["]m"] = { query = "@function.outer", desc = "Next method/function def start" },
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
              ["]l"] = { query = "@loop.outer", desc = "Next loop start" },
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]F"] = { query = "@call.outer", desc = "Next function call end" },
              ["]M"] = { query = "@function.outer", desc = "Next method/function def end" },
              ["]C"] = { query = "@class.outer", desc = "Next class end" },
              ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
              ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
            },
            goto_previous_start = {
              ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
              ["[m"] = { query = "@function.outer", desc = "Prev method/function def start" },
              ["[c"] = { query = "@class.outer", desc = "Prev class start" },
              ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
              ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
            },
            goto_previous_end = {
              ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
              ["[M"] = { query = "@function.outer", desc = "Prev method/function def end" },
              ["[C"] = { query = "@class.outer", desc = "Prev class end" },
              ["[I"] = { query = "@conditional.outer", desc = "Prev conditional end" },
              ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
            },
          },
        },
      })
    end,
  },

  -- lazy.nvim의 자동 소싱(plugin/ 스크립트 로드)을 완전히 우회하되 플러그인이 삭제되지 않도록 lazy = true 처리
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
  },
}
