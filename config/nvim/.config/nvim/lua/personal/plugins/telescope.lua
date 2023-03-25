return {
    {
      'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' },
      cmd = { 'Telescope' },
      init = function()
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
      end
    }
}
