-- lua/autocmds.lua
_G.SNACKS_RESOLVE = function(path)
  local vault_root = vim.fn.expand("~/Github/docs/obsidian-sync")
  local attachments_dir = vault_root .. "/Attachments"

  local function file_exists(p)
    return (vim.uv and vim.uv.fs_stat(p) ~= nil) or (vim.loop and vim.loop.fs_stat(p) ~= nil)
  end

  local function ci_match(dir, fname)
    local target = fname:lower()
    local ok, iter = pcall(vim.fs.dir, dir)
    if not ok then
      return nil
    end
    for name, typ in iter do
      if typ == "file" and name:lower() == target then
        return dir .. "/" .. name
      end
    end
    return nil
  end

  local function try_extensions(dir, stem)
    local exts = { ".png", ".jpg", ".jpeg", ".webp", ".gif" }
    for _, ext in ipairs(exts) do
      local cand = dir .. "/" .. stem .. ext
      if file_exists(cand) then
        return cand
      end
      local ci = ci_match(dir, stem .. ext)
      if ci then
        return ci
      end
    end
    return nil
  end

  -- 공백/따옴표 정리
  path = (vim.fn.trim and vim.fn.trim(path)) or path
  path = path:gsub('^"', ""):gsub('"$', ""):gsub("^'", ""):gsub("'$", "")

  -- .md/.markdown은 스킵
  local lower = path:lower()
  if lower:match("%.mark?down$") or lower:match("%.md$") then
    vim.notify("[resolve skip] in=" .. path)
    return nil
  end

  -- http(s) 링크는 그대로
  if path:match("^https?://") then
    return path
  end

  -- (A) 경로에 슬래시가 있든 없든: 현재 문자열이 가리키는 파일이 실제로 있으면 그대로
  if file_exists(path) then
    vim.notify("[resolve_file exist] in=" .. path)
    return path
  end

  -- basename 추출해서 Attachments 우선으로 재시도
  local base = vim.fn.fnamemodify(path, ":t")
  if base ~= "" then
    -- Attachments 직접 매치
    local cand = attachments_dir .. "/" .. base
    if file_exists(cand) then
      vim.notify("[resolve_attachment] in=" .. path)
      return cand
    end

    -- Attachments 확장자 보정
    local stem = base:gsub("%.[^./]+$", "")
    local fixed = try_extensions(attachments_dir, stem)
    if fixed then
      return fixed
    end

    -- 현재 문서 디렉터리 쪽도 재시도
    local curdir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
    local local_cand = curdir .. "/" .. base
    if file_exists(local_cand) then
      return local_cand
    end

    local fixed_local = try_extensions(curdir, stem)
    if fixed_local then
      return fixed_local
    end

    -- 대소문자 무시 직접 매치
    local ci1 = ci_match(attachments_dir, base)
    if ci1 then
      return ci1
    end
    local ci2 = ci_match(curdir, base)
    if ci2 then
      return ci2
    end
  end

  -- 마지막으로 원문 유지(디버깅)
  return path
end
vim.api.nvim_create_user_command("ImgResolve", function(opts)
  -- print(vim.inspect((function(path)
  --   print(vim.inspect(_G.SNACKS_RESOLVE(opts.args)))
  -- end)(opts.args)))
  print(_G.SNACKS_RESOLVE(opts.args))
end, { nargs = 1 })

local aug = vim.api.nvim_create_augroup

-- ==========================
-- Highlight when yanking (copying) text
-- ==========================
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
local grp_yank = aug("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = grp_yank,
  desc = "Highlight on yank",
  callback = function()
    vim.hl.on_yank()
    -- pcall(vim.highlight.on_yank, { higroup = "IncSearch", timeout = 120 })
  end,
})

-- ==========================
-- Remove trailing whitespace
-- ==========================
local grp_trim = aug("TrimWhitespaceOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = grp_trim,
  pattern = "*",
  callback = function(args)
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  desc = "Trim trailing whitespace on save",
})

-- ==========================
-- Obsidian front-matter 'modified' 자동 갱신 + diff 체크
-- ==========================
local OBSIDIAN_VAULT = vim.fn.expand("$MY_VAULT")

local function in_vault(path)
  path = vim.fn.fnamemodify(path, ":p")
  return path:sub(1, #OBSIDIAN_VAULT) == OBSIDIAN_VAULT
end

-- frontmatter 범위 찾기(맨 위 --- ... --- 만 frontmatter로 간주)
local function find_frontmatter_bounds(lines)
  if not lines[1] or not lines[1]:match("^%-%-%-$") then
    return nil, nil
  end
  for i = 2, #lines do
    if lines[i]:match("^%-%-%-$") then
      return 1, i
    end
  end
  return nil, nil
end

-- 'modified:' 라인을 제외한 정규화 콘텐츠 해시(내용 변화만 감지)
local function normalized_fingerprint(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local s, e = find_frontmatter_bounds(lines)
  if s and e then
    local copy = {}
    for i = 1, #lines do
      if i > s and i < e and lines[i]:match("^%s*modified:%s*") then
        -- modified 라인은 해시에서 제외
      else
        table.insert(copy, lines[i])
      end
    end
    return vim.fn.sha256(table.concat(copy, "\n"))
  else
    return vim.fn.sha256(table.concat(lines, "\n"))
  end
end

-- frontmatter에 modified 필드를 now로 세팅(있으면 교체, 없으면 추가/블록 생성)
local function upsert_modified(bufnr, now)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local s, e = find_frontmatter_bounds(lines)

  local function set_line(idx)
    lines[idx] = ("modified: %s"):format(now)
  end

  if s and e then
    local found = false
    for i = s + 1, e - 1 do
      if lines[i]:match("^%s*modified:%s*") then
        set_line(i)
        found = true
        break
      end
    end
    if not found then
      table.insert(lines, e, ("modified: %s"):format(now))
      e = e + 1
    end
  else
    -- frontmatter가 없으면 새로 만들어 맨 위에 삽입
    -- local new = { "---", ("modified: %s"):format(now), "---" }
    -- for i = #new, 1, -1 do
    --   table.insert(lines, 1, new[i])
    -- end
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

local grp_ob = aug("ObsidianModifiedStamp", { clear = true })

-- 저장 직전: 내용 변화가 있을 때만 modified 갱신
vim.api.nvim_create_autocmd("BufWritePre", {
  group = grp_ob,
  pattern = { "*.md", "*.markdown" },
  desc = "Update frontmatter 'modified' only when content changed",
  callback = function(args)
    if not in_vault(args.file) then
      return
    end

    -- 버퍼 내용 기준으로 변경이 아예 없으면(일반적으론 write 자체가 안 되지만) 스킵
    -- 또는 외부 플러그인 강제 저장을 대비해 정규화 해시 비교도 사용
    local curr_fp = normalized_fingerprint(args.buf)
    local last_fp = vim.b.obsidian_last_saved_fp

    if last_fp and last_fp == curr_fp then
      -- 내용 변화 없음 → modified 안 건드림
      return
    end

    -- 내용이 바뀐 경우에만 modified 갱신
    local now = os.date("%Y-%m-%d %H:%M")
    upsert_modified(args.buf, now)
  end,
})

-- 저장 직후: 이번 저장본의 정규화 해시를 기억(다음 저장 때 비교)
vim.api.nvim_create_autocmd("BufWritePost", {
  group = grp_ob,
  pattern = { "*.md", "*.markdown" },
  desc = "Cache normalized fingerprint after save",
  callback = function(args)
    if not in_vault(args.file) then
      return
    end
    vim.b.obsidian_last_saved_fp = normalized_fingerprint(args.buf)
  end,
})
