return {
    {
        'github/copilot.vim',
        config = function()
            vim.g.copilot_filetypes = {markdown = true}
        end,
    },
    'tpope/vim-eunuch', -- Helpers for UNIX (Move, Rename, etc)
    'tpope/vim-unimpaired',
    {
        -- Seamless navigation in vim and tmux
        'christoomey/vim-tmux-navigator',
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    'roman/golden-ratio', -- Makes current split bigger
    'arecarn/vim-crunch', -- Maths in VIM!
    -- {
    --     "tiagovla/tokyodark.nvim",
    --     lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         vim.g.tokyodark_transparent_background = true
    --         vim.g.tokyodark_enable_italic_comment = true
    --         vim.g.tokyodark_enable_italic = true
    --         vim.g.tokyodark_color_gamma = "1.0"
    --         vim.cmd.colorscheme("tokyodark")
    --     end,
    -- },
    {
        'terrortylor/nvim-comment',
        config = function()
            require('nvim_comment').setup()
        end
    },
    {
        'kylechui/nvim-surround',
        config = function()
            require("nvim-surround").setup({})
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
    {
        'elkowar/yuck.vim',
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        'vim-test/vim-test',
        dependencies = { 'christoomey/vim-tmux-runner'},
        config = function()
            vim.g['test#strategy'] = 'vtr'
        end,
    },
    {
        'sindrets/diffview.nvim',
    },
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      config = true
    },
    {
      'nvim-orgmode/orgmode',
      event = 'VeryLazy',
      ft = { 'org' },
      config = function()
        -- Setup orgmode
        require('orgmode').setup({
          -- org_agenda_files = '~/orgfiles/**/*',
          -- org_default_notes_file = '~/orgfiles/refile.org',
        })

        -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
        -- add ~org~ to ignore_install
        -- require('nvim-treesitter.configs').setup({
        --   ensure_installed = 'all',
        --   ignore_install = { 'org' },
        -- })
      end,
    }
}
