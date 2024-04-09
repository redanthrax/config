require "nvchad.mappings"
local map = vim.keymap.set

map("n", "<leader>gg", "<cmd> LazyGit <CR>", { desc = "LazyGit"})

