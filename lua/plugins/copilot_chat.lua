return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		enabled = true,
		dependencies = {
			-- { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- Enable or disable Copilot Chat
			enabled = true,
			-- Set the maximum number of suggestions to display
			max_suggestions = 10,
			-- Customize the appearance of the chat window
			window = {
				border = "rounded", -- options: 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
				width = 80,
				height = 20,
			},
			-- Keybindings for navigating suggestions
			keymaps = {
				accept = "<C-y>",
				next = "<C-n>",
				prev = "<C-p>",
			},
		},
		keys = {
			{ "<leader>cb", ":CopilotChat!<CR>", desc = "Open Copilot Chat withot the current buffer context" },
			{ "<leader>cc", ":CopilotChat<CR>", desc = "Open Copilot Chat" },
			{ "<leader>cv", ":'<,'>CopilotChat<CR>", mode = "v", desc = "Open Copilot Chat with selection" },
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
