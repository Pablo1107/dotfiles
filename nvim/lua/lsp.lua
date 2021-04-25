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
