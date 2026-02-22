return {
  cmd = {
    "/opt/homebrew/opt/llvm/bin/clangd",
    "--log=verbose",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--compile-commands-dir=build",
    "--suggest-missing-includes",
    "--completion-style=detailed",
    "--include-ineligible-results",
    "--clang-tidy-checks=performance-*,bugprone-*",
    --"--query-driver=/usr/bin/gcc,/usr/bin/g++,/usr/local/gcc-15,/usr/bin/clang,/Library/Developer/CommandLineTools/usr/bin/c++",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
}
