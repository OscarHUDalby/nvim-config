return {
  enabled = false,
  "https://github.com/Maan2003/lsp_lines.nvim",
  event = "VeryLazy",
  config = function()
    require("lsp_lines").setup()

    vim.diagnostic.config({
      virtual_text = false,
    })

    vim.keymap.set("n", "<leader>ll", require("lsp_lines").toggle, { desc = "Toggle LSP Lines" })
  end,
}
