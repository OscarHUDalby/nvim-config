return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      model = "gpt-5.2",
      temperature = 0.1,
      window = {
        layout = "vertical",
        width = 0.5,
      },
      auto_insert_mode = true,
    },
    keys = (function()
      return {
        { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
        { "<leader>cr", "<cmd>CopilotChatReset<cr>",  desc = "Reset Copilot Chat" },
        { "<leader>cs", "<cmd>CopilotChatSave<cr>",   desc = "Save Copilot Chat" },
        { "<leader>cl", "<cmd>CopilotChatLoad<cr>",   desc = "Load Copilot Chat" },
      }
    end)(),
  },
}
