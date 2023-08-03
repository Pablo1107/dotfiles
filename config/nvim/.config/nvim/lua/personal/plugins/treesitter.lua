return {
    {
      'nvim-treesitter/nvim-treesitter',
      config = function()
        require('nvim-treesitter.configs').setup {
          -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
          highlight = {
            enable = true, -- false will disable the whole extension
          },
        }
      end
    },
    'romgrk/nvim-treesitter-context',
}
