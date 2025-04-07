return {
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = false,
		config = function()
			require("refactoring").setup({
				-- prompt for return type
				prompt_func_return_type = {
					go = true,
					cpp = true,
					c = true,
					java = true,
				},
				-- prompt for function parameters
				prompt_func_param_type = {
					go = true,
					cpp = true,
					c = true,
					java = true,
				},
			})

			-- Keymaps
			-- Extract function
			vim.keymap.set({ "n", "v" }, "<leader>rf", function()
				require("refactoring").refactor("Extract Function")
			end)

			-- Extract function to file
			vim.keymap.set({ "n", "v" }, "<leader>rF", function()
				require("refactoring").refactor("Extract Function To File")
			end)

			-- Extract variable
			vim.keymap.set({ "n", "v" }, "<leader>rv", function()
				require("refactoring").refactor("Extract Variable")
			end)

			-- Inline variable
			vim.keymap.set({ "n", "v" }, "<leader>ri", function()
				require("refactoring").refactor("Inline Variable")
			end)

			-- Extract block
			vim.keymap.set({ "n", "v" }, "<leader>rb", function()
				require("refactoring").refactor("Extract Block")
			end)

			-- Extract block to file
			vim.keymap.set({ "n", "v" }, "<leader>rB", function()
				require("refactoring").refactor("Extract Block To File")
			end)

			-- Print function debug information
			vim.keymap.set("n", "<leader>rp", function()
				require("refactoring").debug.printf({ below = false })
			end)

			-- Print variable debug info
			vim.keymap.set("n", "<leader>rv", function()
				require("refactoring").debug.print_var()
			end)

			-- Clean up debug prints
			vim.keymap.set("n", "<leader>rc", function()
				require("refactoring").debug.cleanup({})
			end)

			-- Prompt for refactoring
			vim.keymap.set({ "n", "v" }, "<leader>rr", function()
				require("refactoring").select_refactor()
			end)

			-- Telescope integration
			vim.keymap.set({ "n", "v" }, "<leader>rt", function()
				require("telescope").extensions.refactoring.refactors()
			end)
		end,
	},
}
