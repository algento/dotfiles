return {
  "ahmedkhalf/project.nvim",
  init = function()
    require("project_nvim").setup({
      -- your configuration comes her
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- ignore_lsp = { "lua_ls" },
      detection_methods = { "pattern", "lsp" },
      patterns = {
        "my-root.txt", -- 내가 원하는 마커
        ".git", -- git 기준
        "package.json", -- JS/TS 기준
        "pyproject.toml", -- Python 기준
        "Cargo.toml", -- Rust 기준
        "Makefile",
        "init.lua", -- Nvim config 기준
      },
      show_hidden = true,
    })

    -- Absolutely minimal implementation of fzf-lua based project finder
    -- for fzf-lua, due to request from @KrisWilliams1 (Maybe extended to a
    -- full blown port from the original selector in the future)
    local history = require("project_nvim.utils.history")
    local project = require("project_nvim.project")

    vim.api.nvim_create_user_command("FzfProjects", function()
      local projects = history.get_recent_projects()

      require("fzf-lua").fzf_exec(projects, {
        prompt = "Projects> ",
        actions = {
          ["default"] = function(selected)
            if selected and #selected > 0 then
              local project_path = selected[1]
              if project.set_pwd(project_path, "fzf-lua") then
                require("fzf-lua").files()
              end
            end
          end,
        },
      })
    end, {})
  end,
  keys = {
    {
      "<leader>fp",
      "<cmd>FzfProjects<CR>",
      desc = "Find Recent Projects",
    },
  },
}
