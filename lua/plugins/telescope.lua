return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")

      local function project_root()
        local root = vim.fs.root(0, { ".git", "package.json", "pyproject.toml", "go.mod" })
        return root or vim.loop.cwd()
      end

      vim.keymap.set("n", "<C-p>", function()
        builtin.find_files({ cwd = project_root() })
      end, { desc = "open telescope in project scope" })

      vim.keymap.set("n", "<leader>fp", function()
        builtin.live_grep({ cwd = project_root() })
      end, { desc = "file grep in project scope" })

      vim.keymap.set("n", "<leader>fs", function()
        builtin.live_grep({ search_dirs = { "/" } })
      end, { desc = "grep system-wide" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "node_modules" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
