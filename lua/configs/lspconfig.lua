require("nvchad.configs.lspconfig").defaults()

-- to configure lsps further read :h vim.lsp.config
-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "eslint", "graphql", "pyright", "gopls", "sqls", "pylsp" }
local nvlsp = require "nvchad.configs.lspconfig"

vim.lsp.enable(servers)
