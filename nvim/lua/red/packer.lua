-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
    use("wbthomason/packer.nvim")
    use("folke/tokyonight.nvim")
    use("gruvbox-community/gruvbox")
    use("nvim-lua/plenary.nvim")
    use("TimUntersberger/neogit")
    use("nvim-lua/popup.nvim")
    use("kyazdani42/nvim-web-devicons")
    use("nvim-telescope/telescope.nvim")
    use("preservim/nerdtree")
    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")

    use("akinsho/toggleterm.nvim")

    use("kdheepak/lazygit.nvim")
    use("Yggdroot/indentLine")

    -- cmp autocomplete stuff
    use("neovim/nvim-lspconfig")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")
    use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("glepnir/lspsaga.nvim")
    use("simrat39/symbols-outline.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")

    use("xiyaowong/nvim-transparent")

    use {'shaunsingh/oxocarbon.nvim', run = './install.sh'}
    use("tpope/vim-abolish")
    use("olimorris/onedarkpro.nvim")
    use("mfussenegger/nvim-lint")
    use("darrikonn/vim-gofmt")
    use("xuhdev/vim-latex-live-preview")
end)
