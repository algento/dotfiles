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
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- 최신 안정 버전
    -- ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      --   "BufReadPre path/to/my-vault/*.md",
      --   "BufNewFile path/to/my-vault/*.md",
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "/Github/docs/obsidian-sync/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Github/docs/obsidian-sync/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "2ndbrain",
          path = "~/Github/docs/obsidian-sync/", -- Obsidian vault 경로
        },
      },
      notes_subdir = "0. Inbox",
      note_id_func = function(title)
        -- 제목을 안 넣고 만들면 백업 규칙(날짜-난수)
        if not title or title == "" then
          return os.date("%Y%m%d") .. "-" .. tostring(math.random(1000, 9999))
        end
        -- 파일명에 안전하지 않은 문자만 치환
        local safe = title:gsub('[/\\:*?"<>|]', "-"):gsub("%s+$", ""):gsub("^%s+", "")
        return safe
      end,
      templates = {
        folder = "3. Resources/Templates",
      },
      -- 새 노트의 frontmatter를 통제하고 싶을 때(원치 않는 기본 템플릿 느낌 제거)
      -- note_frontmatter_func = function(note)
      --   -- note: { id, title, aliases, tags }
      --   local out = {
      --     title = note.title,
      --     tags = note.tags,
      --     created = os.date("%Y-%m-%d %H:%M"),
      --     modified = os.date("%Y-%m-%d %H:%M"),
      --     type = "literature-note",
      --     kanban = "to-do",
      --     links = note.links,
      --   }
      --   return out
      -- end,
      frontmatter = {
        enabled = false,
      },
      finder = "fzf-lua", -- finder로 fzf-lua 사용
      completion = {
        blink = true,
      },
      -- (선택) 레거시 커맨드 숨기기
      legacy_commands = false,
    },
    keys = {
      {
        "<leader>on",
        function()
          local DEFAULT_TEMPLATE = "yaml-front-matter" -- templates/ 아래 실제 파일명
          local title = vim.fn.input("Title: ")
          if title == nil or title == "" then
            return
          end
          vim.cmd(("Obsidian new_from_template %s %s"):format(title, DEFAULT_TEMPLATE))
        end,
        desc = "New Obsidian note from default template",
        mode = "n",
        silent = true,
      },
      -- { "<leader>oo", "<cmd>ObsidianSearch<cr>", desc = "Search Obsidian notes", mode = "n" },
      -- { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch", mode = "n" },
      -- { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show location list of backlinks", mode = "n" },
      -- { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Follow link under cursor", mode = "n" },
    },
  },
}
