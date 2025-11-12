return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules/", ".git/", "dist/", "build/", ".venv", "venv" }
      }
    })

    vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
    vim.keymap.set("n", "<space>ff", ":Telescope find_files<CR>")
  end,
}
