return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig

    opts = {
      completions = {
        -- lsp = { enabled = true },
      },
      update_in_insert = false,
      debounce = 150,
      file_types = { "markdown", "quarto", "rmd" }, -- 렌더링할 파일 타입 지정
      heading = {
        enabled = true,
        -- signs = false, -- 왼쪽 사인컬럼 표시 여부
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
        border = true,
        -- border_virtual = true,
        -- position = "inline", -- "inline" | "floating"
      },
      code = {
        enabled = true,
        style = "full", -- "full" = 테두리 + 배경 / "minimal" = 단순 박스
        language_border = " ",
        language_left = "",
        language_right = "",
        left_pad = 2,
        right_pad = 4,
        highlight = "CursorLine", -- 코드 블록 배경색 하이라이트
      },
      table = {
        enabled = true,
        border = "thin",
        -- border_virtual = true,
      },
      latex = {
        enabled = false, -- use snacks.image
      },
      html = {
        enabled = true,
        comment = {
          -- Turn on / off HTML comment concealing
          conceal = false,
        },
      },
    },
  },

  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      symbol_folding = {
        -- Unfold entire symbol tree by default with false,
        -- otherwise enter a number starting from 1
        autofold_depth = false,
        -- autofold_depth = 1,
      },
      -- outline_window = {
      --   position = "right",
      --   width = 30,
      -- },
      -- preview_window = {
      --   live = false,
      -- },
    },
  },

  {
    -- obsidian식 하이라이트 (== ==)를 랜더링하기 위함.
    -- https://chatgpt.com/share/68ecdf5a-8d9c-8003-be97-f1130679e92e
    "nvim-mini/mini.hipatterns",
    event = "VeryLazy",
    opts = function()
      return {
        highlighters = {
          -- ==이후부터 ==직전까지를 캡처로 지정 (안쪽만 하이라이트)
          obsidian_highlight = {
            pattern = "==().-()==",
            group = "ObsidianHighlight",
            extmark_opts = { priority = 2000 }, -- TS/render-markdown보다 강하게
          },
        },
      }
    end,
    config = function(_, opts)
      -- 1) 색 정의
      vim.api.nvim_set_hl(0, "ObsidianHighlight", { fg = "#FFD700", bg = "NONE", bold = true })

      -- 2) 컬러스킴 바뀔 때도 유지
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "ObsidianHighlight", { fg = "#FFD700", bg = "NONE", bold = true })
        end,
      })

      -- 3) 반드시 setup 호출 (highlighters 비어있지 않아야 적용)
      require("mini.hipatterns").setup(opts)
    end,
  },

  --[[ {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "Markd::ownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  }, ]]

  --[[  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      -- You can choose one of the following pickers
      "nvim-telescope/telescope.nvim",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.pick",
      "folke/snacks.nvim",
    },
  }, ]]

  {
    "hakonharnes/img-clip.nvim",
    opts = {
      default = {
        prompt_for_file_name = false,
        dir_path = "/Users/sejong/Github/sejong-wiki/resources/figs", -- obsidian inbox 기준의 상대 경로
        -- relative_to_current_file = true, -- 현재 노트 기준 상대경로로 삽입
        insert_mode_after_paste = true,
        use_absolute_path = false,
        file_name = function()
          return os.date("%Y-%m-%d-%H%M")
        end,
      },
      filetypes = {
        markdown = {
          template = "![](Resources/Figs/$FILE_NAME)$CURSOR",
        },
      },
    },
    keys = {
      -- 클립보드 이미지 → 파일 저장 → `![]()` 자동 삽입
      {
        "<leader>ip",
        function()
          require("img-clip").paste_image()
        end,
        mode = "n",
        desc = "Paste image from clipboard",
      },
      -- 파일 드래그&드롭도 지원 (터미널이 텍스트로 경로를 보낼 때)
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    branch = "main",
    -- ft = "markdown",
    event = {
      -- refer to `:h file-pattern` for more examples
      --   "BufReadPre path/to/my-vault/*.md",
      --   "BufNewFile path/to/my-vault/*.md",
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "/Github/sejong-wiki/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Github/sejong-wiki/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "2ndbrain",
          path = vim.fn.expand("~/Github/sejong-wiki/"), -- Obsidian vault 경로
        },
      },
      ui = {
        enable = false,
      },
      attachments = {
        folder = "resources/figs",
        -- 붙여넣기 시 자동 이름 규칙 설정 (선택)
        image_text_func = function(path)
          local name = vim.fs.basename(tostring(path))
          local encoded = require("obsidian.util").urlencode(name)
          return string.format("![%s](%s)", name, string.match(encoded, "Resources/Figs/.*"))
        end,
      },
      notes_subdir = "(+)",
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
        folder = "resources",
      },
      --[[ -- 새 노트의 frontmatter를 통제하고 싶을 때(원치 않는 기본 템플릿 느낌 제거)
      note_frontmatter_func = function(note)
        -- note: { id, title, aliases, tags }
        local out = {
          title = note.title,
          tags = note.tags,
          created = os.date("%Y-%m-%d %H:%M"),
          modified = os.date("%Y-%m-%d %H:%M"),
          type = "literature-note",
          kanban = "to-do",
          links = note.links,
        }
        return out
      end, ]]
      frontmatter = {
        enabled = false,
      },
      picker = { name = "fzf-lua" },
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
      { "<leader>oo", "<cmd>Obsidian search<cr>", desc = "Search Obsidian notes", mode = "n" },
      { "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Quick Switch", mode = "n" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Show location list of backlinks", mode = "n" },
      { "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Follow link under cursor", mode = "n" },
      -- { "<leader>op", "<cmd>Obsidian paste_img<cr>", mode = { "n", "i" }, desc = "Paste image from clipboard" },
    },
  },
}
