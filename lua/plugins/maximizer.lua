return {
	"szw/vim-maximizer",
	config = function()
		vim.keymap.set("n", "<leader>mm", "<cmd>MaximizerToggle<CR>")
	end,
}
