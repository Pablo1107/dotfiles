local packer_path = vim.fn.stdpath('data') .. '/site/pack/*/start/*,'
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local compile_path = vim.fn.stdpath("config") .. "/generated/packer_compiled.vim"

local function plugins()
  return require('packer').startup({ function(use)
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'
    use {
      'terrortylor/nvim-comment',
      config = function()
        require('nvim_comment').setup()
      end
    }
    -- use 'JoosepAlviste/nvim-ts-context-commentstring'
    -- use 'sheerun/vim-polyglot'
    use 'tpope/vim-eunuch' -- Helpers for UNIX (Move, Rename, etc)
    -- use 'tpope/vim-unimpaired'
    use({
      'kylechui/nvim-surround',
      config = function()
        require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    })
    use 'christoomey/vim-tmux-navigator' -- Seamless navigation in vim and tmux
    use 'roman/golden-ratio' -- Makes current split bigger
    use {
      'norcalli/nvim-colorizer.lua', -- Colorize hex colors strings
      config = function()
        vim.opt.termguicolors = true
        require('colorizer').setup()
      end
    }

    -- use 'folke/tokyonight.nvim'
    -- 'ghifarit53/tokyonight-vim',
    use {
      'tiagovla/tokyodark.nvim',
      config = function()
        vim.g.tokyodark_transparent_background = true
        vim.g.tokyodark_enable_italic_comment = true
        vim.g.tokyodark_enable_italic = true
        vim.g.tokyodark_color_gamma = "1.0"
        vim.cmd("colorscheme tokyodark")
      end
    }
    use 'arecarn/vim-crunch' -- Maths in VIM!

    use {
      'lewis6991/gitsigns.nvim',
      event = 'BufEnter',
      config = function()
        require('gitsigns').setup()
      end
    }

    -- lsp stuff
    use {
      'neovim/nvim-lspconfig',
      config = function()
        require('personal.plugins.nvim-lspconfig')
      end
    }

    use {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      config = function()
        require('personal.plugins.nvim-cmp')
      end
    }
    use { 'L3MON4D3/LuaSnip', after = "nvim-cmp" }
    use { 'saadparwaiz1/cmp_luasnip', after = "nvim-cmp" }
    use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
    use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
    use { 'octaltree/cmp-look', after = "nvim-cmp" }
    use { 'hrsh7th/cmp-path', after = "nvim-cmp" }
    use { 'hrsh7th/cmp-calc', after = "nvim-cmp" }
    use { 'f3fora/cmp-spell', after = "nvim-cmp" }
    use { 'hrsh7th/cmp-emoji', after = "nvim-cmp" }

    use {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require 'nvim-treesitter.configs'.setup {
          auto_install = true,
          -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
          highlight = {
            enable = true, -- false will disable the whole extension
          },
        }
      end
    }
    use {
      'folke/trouble.nvim',
      opt = true,
      cmd = { 'Trouble' },
      config = function()
        require("trouble").setup {
          -- auto_open = true,
          -- auto_close = true,
          -- auto_preview = true,
          -- auto_fold = true,
        }
      end
    }
    --   Plug 'ray-x/lsp_signature.nvim'
    --   Plug 'romgrk/nvim-treesitter-context'
    --   Plug 'nvim-treesitter/playground'
    --   Plug 'lervag/wiki.vim'
    --   Plug 'sindrets/diffview.nvim'
    use {
      'luukvbaal/stabilize.nvim',
      config = function() require("stabilize").setup() end
    }
    use {
      'nvim-telescope/telescope.nvim',
      requires = { { 'nvim-lua/plenary.nvim' } },
      cmd = { 'Telescope' },
      setup = function()
        vim.cmd [[
        nnoremap <C-P> <cmd>Telescope find_files<cr>
        nnoremap <M-p> <cmd>Telescope live_grep<cr>
        nnoremap <Leader>b <cmd>Telescope buffers<cr>
        nnoremap <Leader>h <cmd>Telescope oldfiles<cr>
        nnoremap <Leader>H <cmd>Telescope help_tags<cr>
        ]]
      end,
      config = function()
        local actions = require('telescope.actions')
        require('telescope').setup {
          defaults = require('telescope.themes').get_ivy {
            -- Default configuration for telescope goes here:
            -- config_key = value,
            mappings = {
              i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<M-k>"] = actions.move_selection_previous,
                ["<M-j>"] = actions.move_selection_next
              }
            },
            initial_mode = "insert",
            selection_strategy = "reset",
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = { "truncate" },
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            file_ignore_patterns = { "node_modules", ".git" },
          },
          pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
            buffers = {
              sort_mru = true,
              ignore_current_buffer = true,
            },
            find_files = {
              hidden = true,
            },

          },
          extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
          }
        }

        vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
        vim.lsp.handlers["textDocument/implementation"] = require("telescope.builtin").lsp_implentations
        vim.lsp.handlers["textDocument/definition"] = require("telescope.builtin").lsp_definitions
        vim.lsp.handlers["textDocument/typeDefinition"] = require("telescope.builtin").lsp_type_definitions
        vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
        vim.lsp.handlers["workspace/symbol"] = require("telescope.builtin").lsp_workspace_symbols
      end
    }
  end,
    config = {
      compile_path = compile_path
    }
  })
end

-- Update Packer.nvim automatically:
autocmd("BufWritePost", {
  desc = "PackerCompile",
  pattern = "*plugins/*.lua",
  command = "source <afile> | PackerCompile",
})

-- Install packer.nvim, if it isn't present:
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  local success = vim.fn.system(
    { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
  )
  if success then
    vim.opt.runtimepath:append(packer_path)
    vim.opt.packpath:append(packer_path)

    plugins().sync()
    vim.cmd("source " .. compile_path)
  end
else
  plugins()
  vim.cmd("source " .. compile_path)
end

function _G.plugin_loaded(plugin_name)
  local p = _G.packer_plugins
  return p ~= nil and p[plugin_name] ~= nil and p[plugin_name].loaded
end
