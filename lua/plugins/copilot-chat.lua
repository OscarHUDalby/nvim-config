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
      if vim.g.copilotchat_slot == nil then
        vim.g.copilotchat_slot = 1
      end

      local function slot_name(n)
        return ("chat%d"):format(n)
      end

      local function switch_to_slot(n)
        local prev = vim.g.copilotchat_slot or 1
        vim.cmd(("CopilotChatSave %s"):format(slot_name(prev)))
        vim.g.copilotchat_slot = n
        vim.cmd(("CopilotChatLoad %s"):format(slot_name(n)))
      end

      return {
        { "<leader>cc", "<cmd>CopilotChatToggle<cr>",     desc = "Toggle Copilot Chat" },

        { "<leader>cs", "<cmd>CopilotChatSave<cr>",       desc = "Save Copilot Chat" },
        { "<leader>cl", "<cmd>CopilotChatLoad<cr>",       desc = "Load Copilot Chat" },

        { "<leader>c1", function() switch_to_slot(1) end, desc = "CopilotChat: switch to chat 1" },
        { "<leader>c2", function() switch_to_slot(2) end, desc = "CopilotChat: switch to chat 2" },
        { "<leader>c3", function() switch_to_slot(3) end, desc = "CopilotChat: switch to chat 3" },
        { "<leader>c4", function() switch_to_slot(4) end, desc = "CopilotChat: switch to chat 4" },
        { "<leader>c5", function() switch_to_slot(5) end, desc = "CopilotChat: switch to chat 5" },
      }
    end)(),
  },
}
