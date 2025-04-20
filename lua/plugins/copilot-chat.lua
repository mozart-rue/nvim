return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    dependencies = {
      -- { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                       -- Only on MacOS or Linux
    opts = {
      -- Enable or disable Copilot Chat
      enabled = true,
      model = "claude-3.7-sonnet", -- You can use "gpt-3.5-turbo" for faster responses or "gpt-4" for more capabilities
      context = {
        -- Enable codebase awareness
        enable = true,
        -- Include relevant files based on the current buffer
        strategy = {
          -- Include the current file for context
          "buffer",
          -- Include related files in the same directory
          "directory",
          -- Include files referenced by imports/requires
          "references",
          -- Can also add "embeddings" if the plugin supports it
        },
        -- Maximum number of lines to include (adjust based on model context window)
        max_lines = 200,
        -- Filter out non-code files like images, etc.
        include_pattern = { "%.lua$", "%.js$", "%.ts$", "%.jsx?$", "%.tsx?$", "%.py$", "%.go$", "%.dart$" }, -- adjust based on your codebase
      },
      -- Set the maximum number of suggestions to display
      max_suggestions = 10,
      -- Customize the appearance of the chat window
      --
      quit_map = "q", -- Key to exit the window
      prompts = {
        -- Define custom prompts that appear in the prompt selection
        Explain = "Explain how this code works in detail.",
        Refactor = "Refactor this code to improve clarity and readability.",
        FixBug = "Find and fix bugs in this code.",
        Optimize = "Optimize this code for better performance.",
        Docs = "Write documentation for this code.",
        Tests = "Generate unit tests for this code.",
      },
      auto_follow_cursor = false, -- Auto-follow cursor position in chat
      window = {
        -- Your existing window config
        border = "rounded",
        width = 80,
        height = 20,
        title = "Copilot Chat",
        position = "bottom",   -- "bottom", "top", "left", "right"
        auto_execute_code = false, -- Whether to automatically execute code blocks in responses
      },
      -- Keybindings for navigating suggestions
      keymaps = {
        accept = "<C-y>",
        next = "<C-n>",
        prev = "<C-p>",
        close = "q",
        reset = "<C-l>",
        submit_prompt = "<CR>",
        accept_diff = "<C-a>",
      },
    },
    keys = {
      { "<leader>cb", ":CopilotChat!<CR>",        desc = "Open Copilot Chat withot the current buffer context" },
      { "<leader>cc", ":CopilotChat<CR>",         desc = "Open Copilot Chat" },
      { "<leader>cv", ":'<,'>CopilotChat<CR>",    mode = "v",                                                  desc = "Open Copilot Chat with selection" },

      { "<leader>ce", ":CopilotChatExplain<CR>",  desc = "Explain code" },
      { "<leader>ct", ":CopilotChatTests<CR>",    desc = "Generate tests" },
      { "<leader>cr", ":CopilotChatRefactor<CR>", desc = "Refactor code" },
      { "<leader>cf", ":CopilotChatFixBug<CR>",   desc = "Fix bug" },
      { "<leader>co", ":CopilotChatOptimize<CR>", desc = "Optimize code" },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
