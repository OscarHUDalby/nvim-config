-- Add filetype for Kotlin
vim.filetype.add({
  extension = {
    kt = "kotlin",
  },
})

-- Add filetype for JSX/TSX and PICO-8
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

  -- LSP config (autocmd-based, no deprecated lspconfig.setup)
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- TypeScript/TSX/JSX
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "typescriptreact", "typescript.tsx" },
        callback = function()
          vim.lsp.start({
            name = "tsserver",
            cmd = { "typescript-language-server", "--stdio" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ "package.json", "tsconfig.json" }, { upward = true })[1]
            ),
            filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
              vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename Symbol" })
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
            end,
          })
        end,
      })


      -- Go (gopls)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go" },
        callback = function()
          vim.lsp.start({
            name = "gopls",
            cmd = { "gopls" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ "go.mod", ".git" }, { upward = true })[1]
            ),
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr, desc = "Go LSP Function" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
          })
        end,
      })

      -- PICO-8
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "p8" },
        callback = function()
          vim.lsp.start({
            name = "pico8_ls",
            cmd = { "pico8-language-server" },
            root_dir = vim.loop.cwd(),
            filetypes = { "p8" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr, desc = "PICO-8 LSP Function" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
          })
        end,
      })

      -- Kotlin
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "kotlin" },
        callback = function()
          vim.lsp.start({
            name = "kotlin_language_server",
            cmd = { "kotlin-language-server" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ "settings.gradle", "settings.gradle.kts" }, { upward = true })[1]
            ),
            filetypes = { "kotlin" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr, desc = "Kotlin LSP Function" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
          })
        end,
      })

      -- Lua
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "lua" },
        callback = function()
          vim.lsp.start({
            name = "lua_ls",
            cmd = { "lua-language-server" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ ".git", ".luarc.json", ".luarc.jsonc" }, { upward = true })[1]
            ),
            filetypes = { "lua" },
            capabilities = capabilities,
            -- Optionally add on_attach, settings, etc.
          })
        end,
      })

      -- Python (pyright)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "python" },
        callback = function()
          vim.lsp.start({
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ "pyproject.toml", "setup.py", ".git" }, { upward = true })[1]
            ),
            filetypes = { "python" },
            capabilities = capabilities,
          })
        end,
      })

      -- C/C++ (clangd)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        callback = function()
          vim.lsp.start({
            name = "clangd",
            cmd = { "clangd" },
            root_dir = vim.fs.dirname(
              vim.fs.find({ ".clangd", ".git" }, { upward = true })[1]
            ),
            filetypes = { "c", "cpp", "objc", "objcpp" },
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr, desc = "LSP Function" }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            end,
          })
        end,
      })
      -- Add more autocmds for other servers as needed!
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
