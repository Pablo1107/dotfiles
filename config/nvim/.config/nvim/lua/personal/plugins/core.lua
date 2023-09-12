return {
    'github/copilot.vim',
    'tpope/vim-eunuch', -- Helpers for UNIX (Move, Rename, etc)
    'tpope/vim-unimpaired',
    'christoomey/vim-tmux-navigator', -- Seamless navigation in vim and tmux
    'roman/golden-ratio', -- Makes current split bigger
    'arecarn/vim-crunch', -- Maths in VIM!
    {
        "tiagovla/tokyodark.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            vim.g.tokyodark_transparent_background = true
            vim.g.tokyodark_enable_italic_comment = true
            vim.g.tokyodark_enable_italic = true
            vim.g.tokyodark_color_gamma = "1.0"
            vim.cmd.colorscheme("tokyodark")
        end,
    },
    {
      'terrortylor/nvim-comment',
      config = function()
        require('nvim_comment').setup()
      end
    },
    {
      'kylechui/nvim-surround',
      config = function()
        require("nvim-surround").setup({ })
      end
    },
    {
      'norcalli/nvim-colorizer.lua', -- Colorize hex colors strings
      config = function()
        vim.opt.termguicolors = true
        require('colorizer').setup()
      end
    },
    {
      'lewis6991/gitsigns.nvim',
      event = 'BufEnter',
      config = function()
        require('gitsigns').setup()
      end
    },
    -- {
    --   'luukvbaal/stabilize.nvim',
    --   config = function() require("stabilize").setup() end
    -- },
}
