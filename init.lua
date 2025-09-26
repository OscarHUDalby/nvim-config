-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    require("os").exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.wo.number = true

-- Setup lazy.nvim
require("vim-options")
require("lazy").setup("plugins")

-- Format on save
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({ async = false, id = args.data.client_id })
      end,
    })
  end,
})

-- Moving around quickly with CTRL-arrows
vim.keymap.set("n", "<C-Up>", "10k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", "10j", { noremap = true, silent = true })
vim.keymap.set("x", "<C-Up>", "10k", { noremap = true, silent = true })
vim.keymap.set("x", "<C-Down>", "10j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "b", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", "e", { noremap = true, silent = true })

-- Resize splits with shift + arrows
vim.api.nvim_set_keymap("n", "<S-Left>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Right>", ":vertical resize +5<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Up>", ":resize +5<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Down>", ":resize -5<CR>", { noremap = true, silent = true })

-- Set the background/foreground to pure black regardless of theme
vim.api.nvim_set_hl(0, "Normal", { fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg, bg = "black" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#000000", bg = "#000000" })
-- Oil keymap
vim.keymap.set("n", "<Leader>o", ":Oil<CR>", { noremap = true, silent = true })

-- Git keymaps
vim.api.nvim_set_keymap("n", "<leader>ga", ":!git add .<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>gc",
  ':!git commit -m "neovim auto commit"<CR>',
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<leader>gp", ":!git push origin main<CR>", { noremap = true, silent = true })

-- Window title
vim.opt.titlelen = 0
vim.opt.titlestring = [[%{fnamemodify(getcwd(), ':t')} - %t]]
-- Search case behaviour
vim.o.ignorecase = true
vim.o.smartcase = true

-- Split separators
vim.opt.fillchars = { vert = "│", horiz = "-" }
vim.opt.laststatus = 3
vim.cmd([[hi VertSplit guibg=NONE guifg=#001BFF]])

-- Python
vim.api.nvim_set_keymap("n", "<leader>pr", ":term python3 %<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>pm",
  ":w<CR>:vsplit | term python -m " .. vim.fn.expand("%:t:r") .. "<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>pi", ":!pip install -r requirements.txt<CR>", { noremap = true, silent = true })


vim.cmd("let $PYTHONPATH = expand('%:p:h')")


-- increase the tab width in *.py files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

-- Go
require("lspconfig").gopls.setup({})

-- Diagnostics
vim.diagnostic.config({

  virtual_text = {
    spacing = 4,
    prefix = function(diagnostic)
      local icons = { "❌", "⚠️", "💡", "ℹ️" }
      return icons[diagnostic.severity]
    end,
    format = function(diagnostic)
      return string.format("[%s] %s", diagnostic.source, diagnostic.message)
    end,
  }
  ,
  signs = true,
  underline = true,
  severity_sort = true,
})

-- Fix cmp with <CR>
vim.keymap.set("i", "<CR>", function()
  local cmp = require("cmp")

  if cmp.visible() and cmp.get_selected_entry() then
    cmp.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    })
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
  end
end, { noremap = true })

-- Macros
local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
vim.fn.setreg("l", "yoconsole.log(\'" .. esc .. "pa\', " .. esc .. "pa);" .. esc)

-- ktfmt format on save for Kotlin files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.kt",
  callback = function(args)
    local filename = vim.api.nvim_buf_get_name(args.buf)
    local cmd = string.format(
      'java -jar /home/oscar-dalby/GitHub/ktfmt-0.58-with-dependencies.jar --kotlinlang-style "%s"',
      filename
    )
    vim.fn.system(cmd)
    vim.cmd("edit!")
  end,
})

-- Prettier on save for js/ts files and specific directories
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.md" },
  callback = function()
    vim.fn.system("prettier --write ./app/*")
    vim.fn.system("prettier --write ./src/*")
  end,
})

-- Kotlin build/run commands
vim.api.nvim_set_keymap(
  "n",
  "<leader>kb",
  ":!kotlinc src -include-runtime -d app.jar<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>kr", ":!java -jar app.jar<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<leader>kf',
  function()
    local filename = vim.fn.expand('%:p')
    local cmd = string.format(
      'java -jar /home/oscar-dalby/GitHub/ktfmt-0.58-with-dependencies.jar --kotlinlang-style "%s"',
      filename
    )
    vim.fn.system(cmd)
    vim.cmd('edit!')
  end,
  { desc = "Format current file with ktfmt" }
)
