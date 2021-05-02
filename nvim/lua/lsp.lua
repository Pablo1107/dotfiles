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

require('lspconfig').tsserver.setup {}

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
