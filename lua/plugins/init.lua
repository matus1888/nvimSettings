return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require "configs.conform"
    end,
  },
  -- {
  --   "christoomey/vim-tmux-navigator",
  --   lazy = false,
  --   cmd = {
  --     "TmuxNavigateLeft",
  --     "TmuxNavigateDown",
  --     "TmuxNavigateUp",
  --     "TmuxNavigateRight",
  --     "TmuxNavigatePrevious",
  --   },
  -- },
  {
    "stevearc/dressing.nvim",
    lazy = false,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  -- { "nvim-neotest/nvim-nio" },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
        "eslint-lsp",
        -- "gopls",
        -- "js-debug-adapter",
        "typescript-language-server",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "typescript",
        "javascript",
        "graphql",
        -- "go",
      },
    },
  },
  {
    "airblade/vim-gitgutter",
    lazy = false,
  },
  {
    "mfussenegger/nvim-lint",
    lazy = false,
    config = function()
      require "configs.lint"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("chatgpt").setup {}
  --   end,
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  -- {
  --   "nvim-neotest/neotest",
  --   lazy = true,
  --   config = function()
  --     require("neotest").setup {
  --       adapters = {
  --         require "neotest-jest" {
  --           jestCommand = "npm test --",
  --           jestConfigFile = "jest.config.ts",
  --           env = { CI = true },
  --           cwd = function(path)
  --             return vim.fn.getcwd()
  --           end,
  --         },
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "haydenmeade/neotest-jest",
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   config = function()
  --     local ok, dap = pcall(require, "dap")
  --     if not ok then
  --       return
  --     end
  --     dap.configurations.typescript = {
  --       {
  --         type = "node2",
  --         name = "node attach",
  --         request = "attach",
  --         program = "${file}",
  --         cwd = vim.fn.getcwd(),
  --         sourceMaps = true,
  --         protocol = "inspector",
  --       },
  --     }
  --     dap.adapters.node2 = {
  --       type = "executable",
  --       command = "node-debug2-adapter",
  --       args = {},
  --     }
  --   end,
  --   dependencies = {
  --     "mxsdev/nvim-dap-vscode-js",
  --   },
  -- },
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   config = function()
  --     require("dapui").setup()
  --
  --     local dap, dapui = require "dap", require "dapui"
  --
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open {}
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close {}
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close {}
  --     end
  --   end,
  --   dependencies = {
  --     "mfussenegger/nvim-dap",
  --   },
  -- },
  -- {
  --   "folke/neodev.nvim",
  --   config = function()
  --     require("neodev").setup {
  --       library = { plugins = { "nvim-dap-ui" }, types = true },
  --     }
  --   end,
  -- },
  { "tpope/vim-fugitive" },
  {
    "rbong/vim-flog",
    dependencies = {
      "tpope/vim-fugitive",
    },
    lazy = false
  },
  { "sindrets/diffview.nvim", lazy = false },
  -- {
  --   "ggandor/leap.nvim",
  --   lazy = false,
  --   config = function()
  --     require("leap").add_default_mappings(true)
  --   end,
  -- },
  {
    "kevinhwang91/nvim-bqf",
    lazy = false,
  },
  {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    config = function()
      require("todo-comments").setup()
    end,
  }, -- To make a plugin not be loaded
  {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1, -- High priority is needed if you will use `autoremap()`
    config = function()
      require('langmapper').setup({ --[[ your config ]] })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    lazy = false,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    },
  },
  {
    "Pocco81/auto-save.nvim",
    lazy = false,
    config = function()
      require("auto-save").setup {
      }
    end,
    keys = {
      { "<leader>ta", "<cmd>ASToggle<cr>", desc = "toggle autosave" }
    }
  },
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
      require('blame').setup {}
    end,
  },
  {
    "jparise/vim-graphql",
    lazy = false,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
  { "matus1888/telescope-cc.nvim" }
}
