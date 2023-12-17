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

            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.hypr = {
                install_info = {
                    url = "https://github.com/luckasRanarison/tree-sitter-hypr",
                    files = { "src/parser.c" },
                    branch = "master",
                },
                filetype = "hypr",
            }
        end
    },
    'romgrk/nvim-treesitter-context',
    'luckasRanarison/tree-sitter-hypr',
}
