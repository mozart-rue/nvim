return {
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		config = function()
			require("lspsaga").setup({})
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>la", "<Cmd>Lspsaga code_action<CR>", opts)
			vim.keymap.set("n", "<leader>lk", "<Cmd>Lspsaga hover_doc<CR>", opts)
			vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
			vim.keymap.set("n", "<leader>ld", "<Cmd>Lspsaga goto_definition<CR>", opts)
			vim.keymap.set("n", "<leader>lf", "<Cmd>Lspsaga finder<CR>", opts)
			vim.keymap.set("n", "<leader>lo", "<Cmd>Lspsaga outline<CR>", opts)
			vim.keymap.set("n", "<leader>lr", "<Cmd>Lspsaga rename<CR>", opts)

			-- Diagnostics
			vim.keymap.set("n", "<leader>ll", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts)
			vim.keymap.set("n", "<leader>lb", "<Cmd>Lspsaga show_buf_diagnostics<CR>", opts)
			vim.keymap.set("n", "<leader>lw", "<Cmd>Lspsaga show_workspace_diagnostics<CR>", opts)
			vim.keymap.set("n", "<leader>lc", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", opts)

			vim.keymap.set("n", "<M-e>", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
			vim.keymap.set("n", "<M-E>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)

			-- Terminal
			vim.keymap.set("n", "<leader>lt", "<Cmd>Lspsaga term_toggle<CR>", opts)
		end,
	},
}
