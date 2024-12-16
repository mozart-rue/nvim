local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "<leader>pv", vim.cmd.Ex) -- Open built in file explorer
keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Replace matches

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
-- KEEP COMMENTED FOR NOW
-- keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- Split window
keymap.set("n", "zs", ":split<Return>", opts)
keymap.set("n", "zv", ":vsplit<Return>", opts)

-- Move window
keymap.set("n", "zh", "<C-w>h")
keymap.set("n", "zk", "<C-w>k")
keymap.set("n", "zj", "<C-w>j")
keymap.set("n", "zl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- Quickfix list
keymap.set("n", "<M-q>", "<cmd>copen<CR>")
keymap.set("n", "<M-c>", "<cmd>cclose<CR>")
keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
