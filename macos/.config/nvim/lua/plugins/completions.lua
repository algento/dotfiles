return {
  {
    {
      "saghen/blink.compat",
      -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
      version = "*",
      -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
      lazy = true,
      -- make sure to set opts so that lazy.nvim calls blink.compat's setup
      opts = {},
    },
    {
      "saghen/blink.cmp",
      -- optional: provides snippets for the snippet source
      dependencies = {
        "rafamadriz/friendly-snippets",
        "moyiz/blink-emoji.nvim",
        "ray-x/cmp-sql",
      },

      -- use a release tag to download pre-built binaries
      version = "1.*",
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = "default",
          ["<C-Z>"] = { "accept", "fallback" },
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = "mono",
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = true } },
        signature = { enabled = true },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "emoji", "sql" },
          providers = {
            emoji = {
              module = "blink-emoji",
              name = "Emoji",
              score_offset = 15, -- Tune by preference
              opts = { insert = true }, -- Insert emoji (default) or complete its name
              should_show_items = function()
                return vim.tbl_contains(
                  -- Enable emoji completion only for git commits and markdown.
                  -- By default, enabled for all file-types.
                  { "gitcommit", "markdown" },
                  vim.o.filetype
                )
              end,
            },
            sql = {
              -- IMPORTANT: use the same name as you would for nvim-cmp
              name = "sql",
              module = "blink.compat.source",

              -- all blink.cmp source config options work as normal:
              score_offset = -3,

              -- this table is passed directly to the proxied completion source
              -- as the `option` field in nvim-cmp's source config
              --
              -- this is NOT the same as the opts in a plugin's lazy.nvim spec
              opts = {},
              should_show_items = function()
                return vim.tbl_contains(
                  -- Enable emoji completion only for git commits and markdown.
                  -- By default, enabled for all file-types.
                  { "sql" },
                  vim.o.filetype
                )
              end,
            },
          },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" },
      },
      opts_extend = { "sources.default" },
    },
  },

  --[[ {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function(_, opts)
      if opts then
        require("luasnip").config.setup(opts)
      end
      vim.tbl_map(function(type)
        require("luasnip.loaders.from_" .. type).lazy_load()
      end, { "vscode", "snipmate", "lua" })
      -- friendly-snippets - enable standardized comments snippets
      -- require("luasnip").filetype_extend("typescript", { "tsdoc" })
      -- require("luasnip").filetype_extend("javascript", { "jsdoc" })
      -- require("luasnip").filetype_extend("lua", { "luadoc" })
      -- require("luasnip").filetype_extend("python", { "pydoc" })
      -- require("luasnip").filetype_extend("rust", { "rustdoc" })
      -- require("luasnip").filetype_extend("cs", { "csharpdoc" })
      -- require("luasnip").filetype_extend("java", { "javadoc" })
      -- require("luasnip").filetype_extend("c", { "cdoc" })
      -- require("luasnip").filetype_extend("cpp", { "cppdoc" })
      -- require("luasnip").filetype_extend("php", { "phpdoc" })
      -- require("luasnip").filetype_extend("kotlin", { "kdoc" })
      -- require("luasnip").filetype_extend("ruby", { "rdoc" })
      -- require("luasnip").filetype_extend("sh", { "shelldoc" })
      --
    end,
  }, ]]

  --[[ {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
    },
  }, ]]

  --[[ {
    "hrsh7th/nvim-cmp",
    dependecies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
    config = function()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          -- snippet 설정
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        -- 윈도우 시각화 설정
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        -- 키매핑 설정
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-u>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "danymat/neogen",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    version = "*",
  }, ]]
}
