local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "vue",
    -- "c",
    "markdown",
    "markdown_inline",
    "graphql"
    -- "prisma",
    -- "go",
  },
  indent = {
    enable = true,
  },
}

M.mason = {
  ensure_installed = {
    "lua-language-server",
    "css-lsp",
    "html-lsp",
    "ts-ls",
    "deno",
    "prettier",
    "vue-language-server",
    "eslint_d",
    "clangd",
    "clang-format",
    "node-debug2-adapter",
    "gopls",
    "gradle_ls",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
    timeout = 900,
  },
  --
  -- renderer = {
  --   highlight_git = true,
  --   icons = {
  --     show = {
  --       git = true,
  --     },
  --   },
  -- },
}

return M
