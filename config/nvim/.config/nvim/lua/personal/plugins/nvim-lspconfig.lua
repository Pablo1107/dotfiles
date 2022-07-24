-- if not _G.plugin_loaded("nvim-lspconfig") then
--   do return end
-- end

vim.cmd [[
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
]]

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

lspconfig.sumneko_lua.setup {
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

lspconfig.tsserver.setup {
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
}
lspconfig.rnix.setup {}
lspconfig.vimls.setup {}
lspconfig.clangd.setup {}

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local group_id = augroup('lspconfig', {})

autocmd("BufWritePre", {
  group = group_id,
  callback = function()
    vim.lsp.buf.formatting_seq_sync(nil, nil, {
      "tsserver",
      "efm",
    })
  end,
  desc = "Format on quit"
})
