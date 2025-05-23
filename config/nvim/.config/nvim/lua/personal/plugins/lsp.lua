return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', tag = 'legacy', event = "LspAttach", opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',

            'ray-x/lsp_signature.nvim',

            'nvim-telescope/telescope.nvim',
        },
        config = function()
            vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references
            vim.lsp.handlers["textDocument/implementation"] = require("telescope.builtin").lsp_implentations
            vim.lsp.handlers["textDocument/definition"] = require("telescope.builtin").lsp_definitions
            vim.lsp.handlers["textDocument/typeDefinition"] = require("telescope.builtin").lsp_type_definitions
            vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
            vim.lsp.handlers["workspace/symbol"] = require("telescope.builtin").lsp_workspace_symbols

            local map = vim.keymap.set
            map('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
            map('n', 'gD', vim.lsp.buf.declaration, { noremap = true, silent = true })
            map('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
            map('n', 'gi', vim.lsp.buf.implementation, { noremap = true, silent = true })
            map('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
            map('n', '<leader>ca', vim.lsp.buf.code_action, { noremap = true, silent = true })
            map('n', '<leader>rn', vim.lsp.buf.rename, { noremap = true, silent = true })
            map('n', '<leader>f', vim.lsp.buf.format, { noremap = true, silent = true })
            -- map('n', '[d', vim.lsp.diagnostic.goto_prev, { noremap = true, silent = true })
            -- map('n', ']d', vim.lsp.diagnostic.goto_next, { noremap = true, silent = true })

            local lspconfig = require('lspconfig')
            local util = require('lspconfig/util')

            local prettierd = {
                formatCommand = "prettier_d_slim --stdin --stdin-filepath ${INPUT}",
                formatStdin = true
            }
            lspconfig.efm.setup {
                init_options = {
                    documentFormatting = true
                },
                settings = {
                    rootMarkers = { ".git/" },
                    languages = {
                        typescript = { prettierd },
                        javascript = { prettierd },
                        typescriptreact = { prettierd },
                        javascriptreact = { prettierd },
                    },
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "typescriptreact",
                    "javascriptreact",
                }
            }

            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            }

            -- lspconfig.ts_ls.setup {}
            -- lspconfig.vtsls.setup{}
            -- lspconfig.rnix.setup {}
            lspconfig.nixd.setup({
                settings = {
                    nixd = {
                        formatting = {
                            command = { "nixfmt" },
                        },
                    }
                }
            })
            -- lspconfig.nil_ls.setup{}
            lspconfig.vimls.setup {}
            lspconfig.clangd.setup {}

            -- lspconfig.eslint.setup({
            --     --- ...
            --     on_attach = function(_, bufnr)
            --         vim.api.nvim_create_autocmd("BufWritePre", {
            --             buffer = bufnr,
            --             command = "EslintFixAll",
            --         })
            --     end,
            -- })
            lspconfig.rust_analyzer.setup{
              settings = {
                ['rust-analyzer'] = {
                  diagnostics = {
                    enable = false;
                  }
                }
              }
            }

            lspconfig.jdtls.setup {}
            lspconfig.pyright.setup {}
        end
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    -- { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                }, {
                    { name = 'buffer' },
                })
            })

            -- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline('/', {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = {
            --         { name = 'buffer' }
            --     }
            -- })
            -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(':', {
            --     mapping = cmp.mapping.preset.cmdline(),
            --     sources = cmp.config.sources({
            --         { name = 'path' }
            --     }, {
            --         { name = 'cmdline' }
            --     })
            -- })

            -- Setup lspconfig.
            -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- require('lspconfig')['ts_ls'].setup {
            --     capabilities = capabilities
            -- }
            -- -- require('lspconfig')['vtsls'].setup {
            -- --     capabilities = capabilities
            -- -- }
            --
            -- require('lspconfig').asm_lsp.setup {}
        end
    },
    {
        'folke/trouble.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = true,
        cmd = { 'Trouble' },
        config = function()
            require("trouble").setup {
                -- auto_open = true,
                -- auto_close = true,
                -- auto_preview = true,
                -- auto_fold = true,
            }
        end
    },
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
      opts = {},
      config = function()
        require("typescript-tools").setup {
            settings = {
              tsserver_max_memory = 8192,
              tsserver_file_preferences = {
                includeCompletionsForModuleExports = true,
              },
            },
        }
      end,
    },
}
