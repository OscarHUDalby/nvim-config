  -- Add filetype for Kotlin
  vim.filetype.add({
    extension = {
      kt = "kotlin",
    },
  })

  -- Add filetype for JSX/TSX
  vim.filetype.add({
    extension = {
      jsx = "javascriptreact",
      tsx = "typescriptreact",
      p8 = "p8"
    },
  })

return {
  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "tailwindcss",
          "dockerls",
          "gopls",
          "html",
          "spectral",
          "lua_ls",
          "marksman",
          "pico8_ls",
          "pyright",
          "grammarly",
          "ts_ls",
          "clangd",
          "kotlin_language_server",
        },
      })
    end,
  },



  -- LSP config
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- Setup for TypeScript language server
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false -- Use null-ls for formatting
          -- Keymaps
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
        end,
      })

      -- PICO-8 language server setup
      lspconfig.pico8_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Keymaps for LSP functions
          local opts = { buffer = bufnr, desc = "PICO-8 LSP Function" }

          -- Keymap for basic LSP functionality
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)          -- Go to Definition
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- Hover Documentation
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Rename Symbol
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action
        end,
      })

      -- Kotlin language server setup
      lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, desc = "Kotlin LSP Function" }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })

      -- Other servers (e.g., pyright, lua_ls, etc.)
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })

      -- Add clangd for C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- optional: Disable document formatting from LSP, use null-ls or other formatter
          -- client.server_capabilities.documentFormattingProvider = false

          -- Keymaps for LSP functions
          local opts = { buffer = bufnr, desc = "LSP Function" }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)          -- Go to Definition
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)                -- Hover Documentation
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Rename Symbol
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Code Action
        end,
      })
    end,
  },

  -- Completion setup
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },


}
