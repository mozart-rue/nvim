return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  config = function()
    vim.keymap.set("n", "<leader>in", function()
      return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })
  end,
}
