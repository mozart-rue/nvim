return {
  {
    "mistweaverco/kulala.nvim",
    config = function()
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>kr", "<Cmd>lua require('kulala').run()<CR>", opts)
      vim.keymap.set("n", "<leader>kk", "<Cmd>lua require('kulala').replay()<CR>", opts)
      vim.keymap.set("n", "<leader>ki", "<Cmd>lua require('kulala').inspect()<CR>", opts)
      vim.keymap.set("n", "<leader>kd", "<Cmd>lua require('kulala').show_stats()<CR>", opts)
      vim.keymap.set("n", "<leader>kw", "<Cmd>lua require('kulala').scratchpad()<CR>", opts)
      vim.keymap.set("n", "<leader>kc", "<Cmd>lua require('kulala').copy()<CR>", opts)
      vim.keymap.set("n", "<leader>ks", "<Cmd>lua require('kulala').search()<CR>", opts)
      vim.keymap.set("n", "<leader>kt", "<Cmd>lua require('kulala').toggle_view()<CR>", opts)
      vim.keymap.set("n", "<leader>kp", "<Cmd>lua require('kulala').jump_prev()<CR>", opts)
      vim.keymap.set("n", "<leader>kn", "<Cmd>lua require('kulala').jump_next()<CR>", opts)
    end,
  },
}
