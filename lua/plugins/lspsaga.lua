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
		end,
	},
}
