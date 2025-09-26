return {
  dir = "~/GitHub/nvim-simple-notes", -- path to repo "OscarHUDalby/nvim-simple-notes"
  name = "nvim-simple-notes",         -- (optional) for local development
  config = function()
    require("simple_notes")
  end,
}
