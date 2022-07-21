local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

local util = require("packer.util")
local compile_path = util.join_paths(
  vim.fn.stdpath("config"), "generated", "packer_compiled.vim"
)

require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'
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
  -- use 'junegunn/fzf'
  -- use 'junegunn/fzf.vim'
  use 'christoomey/vim-tmux-navigator' -- Seamless navigation in vim and tmux
  use 'roman/golden-ratio' -- Makes current split bigger
  use 'norcalli/nvim-colorizer.lua' -- Colorize hex colors strings

  use 'ghifarit53/tokyonight-vim'
  -- use 'folke/tokyonight.nvim'
  use 'arecarn/vim-crunch' -- Maths in VIM!

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- lsp stuff
  use 'neovim/nvim-lspconfig'

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp",
      "dcampos/nvim-snippy", "dcampos/cmp-snippy",
      'octaltree/cmp-look', 'hrsh7th/cmp-path', 'hrsh7th/cmp-calc',
      'f3fora/cmp-spell', 'hrsh7th/cmp-emoji'
    },
  }
  use 'RishabhRD/popfix'
  use {
    'RishabhRD/nvim-lsputils',
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] = require 'lsputil.codeAction'.code_action_handler
      vim.lsp.handlers['textDocument/references'] = require 'lsputil.locations'.references_handler
      vim.lsp.handlers['textDocument/definition'] = require 'lsputil.locations'.definition_handler
      vim.lsp.handlers['textDocument/declaration'] = require 'lsputil.locations'.declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] = require 'lsputil.locations'.typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] = require 'lsputil.locations'.implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] = require 'lsputil.symbols'.document_handler
      vim.lsp.handlers['workspace/symbol'] = require 'lsputil.symbols'.workspace_handler
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        auto_install = true,
        -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = { "nix", "ledger" }, -- list of language that will be disabled
        },
      }
    end
  }
  use {
    'folke/trouble.nvim',
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
    config = function()
      local darker_black = "#1d1f21"
      local black = "#282a2e"
      local black2 = "#282a2e"
      local white = "#fafafa"
      local red = "#ff5555"
      local green = "#50fa7b"

      local cmd = vim.cmd

      local bg = function(group, col)
        cmd("hi " .. group .. " guibg=" .. col)
      end

      -- Define fg color
      -- @param group Group
      -- @param color Color
      local fg = function(group, col)
        cmd("hi " .. group .. " guifg=" .. col)
      end

      -- Define bg and fg color
      -- @param group Group
      -- @param fgcol Fg Color
      -- @param bgcol Bg Color
      local fg_bg = function(group, fgcol, bgcol)
        cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
      end

      fg_bg("TelescopeBorder", darker_black, darker_black)
      fg_bg("TelescopePromptBorder", black2, black2)

      fg_bg("TelescopePromptNormal", white, black2)
      fg_bg("TelescopePromptPrefix", red, black2)

      bg("TelescopeNormal", darker_black)

      fg_bg("TelescopePreviewTitle", black, green)
      fg_bg("TelescopePromptTitle", black, red)
      fg_bg("TelescopeResultsTitle", darker_black, darker_black)

      bg("TelescopeSelection", black2)

      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup {
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
            sort_lastused = true,
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
      vim.cmd [[
      nnoremap <C-P> <cmd>Telescope find_files<cr>
      nnoremap <M-p> <cmd>Telescope live_grep<cr>
      nnoremap <Leader>b <cmd>Telescope buffers<cr>
      nnoremap <Leader>h <cmd>Telescope oldfiles<cr>
      nnoremap <Leader>H <cmd>Telescope help_tags<cr>
      ]]
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    compile_path = compile_path
  }
})

vim.cmd("source " .. compile_path)

function _G.plugin_loaded(plugin_name)
  local p = _G.packer_plugins
  return p ~= nil and p[plugin_name] ~= nil and p[plugin_name].loaded
end
