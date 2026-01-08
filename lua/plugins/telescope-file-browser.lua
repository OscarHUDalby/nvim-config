return {
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules/", "%.git/", "dist/", "%.cache/", "%.lock", "%.DS_Store" },
        },
        extensions = {
          file_browser = {
            grouped = false,           -- show files and folders in a flat list
            respect_gitignore = false, -- ignore .gitignore
            hidden = true,             --  show hidden files
          },
        },
      })

      require("telescope").load_extension "file_browser"

      vim.keymap.set("n", "<space>ff", function()
        local root = vim.fs.root(0, { ".git", "package.json", "pyproject.toml", "go.mod" }) or vim.loop.cwd()
        require("telescope.builtin").find_files({
          cwd = root,
          hidden = true,
          no_ignore = true,
          follow = true,
          recursive = true,
        })
      end, { desc = "Find files (project root, recursive)" })
    end,
  }
}
