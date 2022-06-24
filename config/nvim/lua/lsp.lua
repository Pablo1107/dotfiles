local util = require 'lspconfig/util'

vim.lsp.set_log_level("debug")

local prettierd = {
    formatCommand = "prettier_d_slim --stdin --stdin-filepath ${INPUT}",
    formatStdin = true
}
require('lspconfig').efm.setup {
    init_options = {
      documentFormatting = true
    },
    settings = {
        rootMarkers = {".git/"},
        languages = {
          typescript = {prettierd},
          javascript = {prettierd},
          typescriptreact = {prettierd},
          javascriptreact = {prettierd},
        },
    },
    filetypes = {
      "javascript",
      "typescript",
      "typescriptreact",
      "javascriptreact",
    }
}

require('lspconfig').tsserver.setup {
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
}

require('lspconfig').rnix.setup{}

require('lspconfig').vimls.setup{}

vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "nix", "ledger" },  -- list of language that will be disabled
  },
}

-- require'treesitter-context.config'.setup{
--     enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
--     context_commentstring = {
--         enable = true,
--     },
--     playground = {
--         enable = true,
--         -- disable = {},
--         -- updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
--         -- persist_queries = false, -- Whether the query persists across vim sessions
--         -- keybindings = {
--         --     toggle_query_editor = 'o',
--         --     toggle_hl_groups = 'i',
--         --     toggle_injected_languages = 't',
--         --     toggle_anonymous_nodes = 'a',
--         --     toggle_language_display = 'I',
--         --     focus_language = 'f',
--         --     unfocus_language = 'F',
--         --     update = 'R',
--         --     goto_node = '<cr>',
--         --     show_help = '?',
--         -- },
--     }
-- }

require("trouble").setup {
    -- auto_open = true,
    -- auto_close = true,
    -- auto_preview = true,
    -- auto_fold = true,
-- your configuration comes here
-- or leave it empty to use the default settings
-- refer to the configuration section below
}

require'lsp_signature'.setup()

require('nvim_comment').setup()

require'lspconfig'.clangd.setup{}

-- Lua
-- local cb = require'diffview.config'.diffview_callback
-- 
-- require'diffview'.setup {
--   diff_binaries = false,    -- Show diffs for binaries
--   enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
--   use_icons = true,         -- Requires nvim-web-devicons
--   icons = {                 -- Only applies when use_icons is true.
--     folder_closed = "",
--     folder_open = "",
--   },
--   signs = {
--     fold_closed = "",
--     fold_open = "",
--   },
--   file_panel = {
--     position = "left",            -- One of 'left', 'right', 'top', 'bottom'
--     width = 35,                   -- Only applies when position is 'left' or 'right'
--     height = 10,                  -- Only applies when position is 'top' or 'bottom'
--     listing_style = "tree",       -- One of 'list' or 'tree'
--     tree_options = {              -- Only applies when listing_style is 'tree'
--       flatten_dirs = true,
--       folder_statuses = "always"  -- One of 'never', 'only_folded' or 'always'.
--     }
--   },
--   file_history_panel = {
--     position = "bottom",
--     width = 35,
--     height = 16,
--     log_options = {
--       max_count = 256,      -- Limit the number of commits
--       follow = false,       -- Follow renames (only for single file)
--       all = false,          -- Include all refs under 'refs/' including HEAD
--       merges = false,       -- List only merge commits
--       no_merges = false,    -- List no merge commits
--       reverse = false,      -- List commits in reverse order
--     },
--   },
--   key_bindings = {
--     disable_defaults = false,                   -- Disable the default key bindings
--     -- The `view` bindings are active in the diff buffers, only when the current
--     -- tabpage is a Diffview.
--     view = {
--       ["<tab>"]      = cb("select_next_entry"),  -- Open the diff for the next file
--       ["<s-tab>"]    = cb("select_prev_entry"),  -- Open the diff for the previous file
--       ["gf"]         = cb("goto_file"),          -- Open the file in a new split in previous tabpage
--       ["<C-w><C-f>"] = cb("goto_file_split"),    -- Open the file in a new split
--       ["<C-w>gf"]    = cb("goto_file_tab"),      -- Open the file in a new tabpage
--       ["<leader>e"]  = cb("focus_files"),        -- Bring focus to the files panel
--       ["<leader>b"]  = cb("toggle_files"),       -- Toggle the files panel.
--     },
--     file_panel = {
--       ["j"]             = cb("next_entry"),           -- Bring the cursor to the next file entry
--       ["<down>"]        = cb("next_entry"),
--       ["k"]             = cb("prev_entry"),           -- Bring the cursor to the previous file entry.
--       ["<up>"]          = cb("prev_entry"),
--       ["<cr>"]          = cb("select_entry"),         -- Open the diff for the selected entry.
--       ["o"]             = cb("select_entry"),
--       ["<2-LeftMouse>"] = cb("select_entry"),
--       ["-"]             = cb("toggle_stage_entry"),   -- Stage / unstage the selected entry.
--       ["S"]             = cb("stage_all"),            -- Stage all entries.
--       ["U"]             = cb("unstage_all"),          -- Unstage all entries.
--       ["X"]             = cb("restore_entry"),        -- Restore entry to the state on the left side.
--       ["R"]             = cb("refresh_files"),        -- Update stats and entries in the file list.
--       ["<tab>"]         = cb("select_next_entry"),
--       ["<s-tab>"]       = cb("select_prev_entry"),
--       ["gf"]            = cb("goto_file"),
--       ["<C-w><C-f>"]    = cb("goto_file_split"),
--       ["<C-w>gf"]       = cb("goto_file_tab"),
--       ["i"]             = cb("listing_style"),        -- Toggle between 'list' and 'tree' views
--       ["f"]             = cb("toggle_flatten_dirs"),  -- Flatten empty subdirectories in tree listing style.
--       ["<leader>e"]     = cb("focus_files"),
--       ["<leader>b"]     = cb("toggle_files"),
--     },
--     file_history_panel = {
--       ["g!"]            = cb("options"),            -- Open the option panel
--       ["<C-d>"]         = cb("open_in_diffview"),   -- Open the entry under the cursor in a diffview
--       ["zR"]            = cb("open_all_folds"),
--       ["zM"]            = cb("close_all_folds"),
--       ["j"]             = cb("next_entry"),
--       ["<down>"]        = cb("next_entry"),
--       ["k"]             = cb("prev_entry"),
--       ["<up>"]          = cb("prev_entry"),
--       ["<cr>"]          = cb("select_entry"),
--       ["o"]             = cb("select_entry"),
--       ["<2-LeftMouse>"] = cb("select_entry"),
--       ["<tab>"]         = cb("select_next_entry"),
--       ["<s-tab>"]       = cb("select_prev_entry"),
--       ["gf"]            = cb("goto_file"),
--       ["<C-w><C-f>"]    = cb("goto_file_split"),
--       ["<C-w>gf"]       = cb("goto_file_tab"),
--       ["<leader>e"]     = cb("focus_files"),
--       ["<leader>b"]     = cb("toggle_files"),
--     },
--     option_panel = {
--       ["<tab>"] = cb("select"),
--       ["q"]     = cb("close"),
--     },
--   },
-- }

local darker_black = "#1d1f21"
local black = "#282a2e"
local black2 = "#282a2e"
local white = "#fafafa"
local red = "#ff5555"
local green = "#50fa7b"

local cmd = vim.cmd

bg = function(group, col)
   cmd("hi " .. group .. " guibg=" .. col)
end

-- Define fg color
-- @param group Group
-- @param color Color
fg = function(group, col)
   cmd("hi " .. group .. " guifg=" .. col)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
fg_bg = function(group, fgcol, bgcol)
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

telescope = require('telescope')
actions = require('telescope.actions')
telescope.setup{
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
    file_ignore_patterns = { "node_modules" },
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
