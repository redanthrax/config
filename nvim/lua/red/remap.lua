local nnoremap = require("red.keymap").nnoremap
local tnoreamp = require("red.keymap").tnoremap

nnoremap("<C-t>", "<cmd>NERDTreeToggle<CR>")
nnoremap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nnoremap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nnoremap("<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
nnoremap("<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")

nnoremap('<C-h>', [[<Cmd>wincmd h<CR>]], opts)
nnoremap('<C-j>', [[<Cmd>wincmd j<CR>]], opts)
nnoremap('<C-k>', [[<Cmd>wincmd k<CR>]], opts)
nnoremap('<C-l>', [[<Cmd>wincmd l<CR>]], opts)

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true , direction = "float"})

function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end

nnoremap('<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<cr>')

nnoremap('<leader>p', '"+p')
nnoremap('<leader>P', '"+P')
nnoremap('<leader>y', '"+y')
nnoremap('<leader>Y', '"+y$')


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

nnoremap('<leader>df', '<cmd>lua vim.diagnostic.open_float()<cr>')

nnoremap('<leader>la', '<cmd>LLPStartPreview<cr>')
