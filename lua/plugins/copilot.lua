return {
  "github/copilot.vim",
  init = function()
    vim.g.copilot_filetypes = {
      json = false,
      sh = false,     -- some .env files are shell scripts
      dotenv = false, -- some .env files are detected as 'dotenv' filetype
    }
  end,
}
