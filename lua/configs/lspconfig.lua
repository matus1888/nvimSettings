local configs = require "nvchad.configs.lspconfig"

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "eslint", "graphql" }
local nvlsp = require "nvchad.configs.lspconfig"

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = nvlsp.on_init,
    -- commands = {
    --   OrganizeImports = {
    --     organize_imports,
    --     description = "Organize Imports",
    --   },
    -- },
    -- settings = {
    --   gopls = {
    --     completeUnimported = true,
    --     usePlaceholders = true,
    --     analyses = {
    --       unusedparams = true,
    --     },
    --   },
    -- },
  }
end

-- lspconfig.ts_ls.setup {
  -- on_attach = nvlsp.on_attach,
  -- capabilities = nvlsp.capabilities,
-- }
