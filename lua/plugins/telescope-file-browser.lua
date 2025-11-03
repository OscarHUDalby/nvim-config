return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "%.cache/", "%.lock", "%.DS_Store" },
      },
      extensions = {
        file_browser = {
          grouped = false,          -- show files and folders in a flat list
          respect_gitignore = true, -- obey .gitignore
          hidden = true,            -- optionally show hidden files
        },
      },
    })

    require("telescope").load_extension "file_browser"

    -- open file_browser with the path of the current buffer
    vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
  end,
}
