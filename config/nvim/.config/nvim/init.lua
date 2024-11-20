--
--      ██╗███╗   ██╗██╗████████╗██╗     ██╗   ██╗ █████╗
--      ██║██╔██╗ ██║██║   ██║   ██║     ██║   ██║███████║
--      ██║██║╚██╗██║██║   ██║   ██║     ██║   ██║██╔══██║
--      ██║██║ ╚████║██║   ██║██╗███████╗╚██████╔╝██║  ██║
--      ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝
--           Author: Pablo Andres Dealbera
--           Year: 2023

vim.g.mapleader = ","

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('personal/lib')
-- ./lua/personal/plugins
require('lazy').setup("personal/plugins")

vim.opt.ttimeoutlen = 100 -- wait up to 100ms after Esc for special key
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.display = 'truncate'
vim.opt.scrolloff = 5
vim.opt.autoread = true -- read files when change outside vim
vim.opt.backupcopy = 'yes'
vim.opt.mouse = 'n'
vim.opt.spelllang = 'en_us,es'
vim.opt.complete:append('kspell')
vim.opt.inccommand = 'nosplit'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.suffixesadd:append('.js,.jsx,.ts,.tsx,.json,.html,.css,.scss,.md,.mdx,.yaml,.yml,.go,.sh,.lua')

-- Tab Sizing
vim.opt.listchars = 'tab:►-,eol:¬,trail:●'
vim.opt.expandtab = true -- on pressing tab, insert 2 spaces
vim.opt.tabstop = 2      -- show existing tab with 2 spaces width
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 0   -- when indenting with '>', use tabstop config

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.termguicolors = true

-- Undo after closing Vim
local undodir_path = vim.fn.stdpath('data') .. '/undo-dir'
if not vim.fn.isdirectory(undodir_path) then
    vim.fn.mkdir(undodir_path, "", 0700)
end
vim.opt.undodir = undodir_path
vim.opt.undofile = true
vim.cmd 'inoremap <C-U> <C-G>u<C-U>' -- allow undu on <C-U>

--  Status Line
vim.opt.laststatus = 2

local get_git_status = function()
    local head = vim.b.gitsigns_head or ''
    local is_head_empty = head ~= ''

    return is_head_empty and string.format('  %s ', head) or ''
end

local statusline = {
    active = function()
        return table.concat({
            '%<',
            '%2*ৰ',
            ' %1* %f %*',
            '%1* %m',
            '%=',
            get_git_status(),
            '%3* %-1.(%)',
            '%3*T%{&tabstop}',
            '%2* L%l',
            '%3* C%c',
            '%3* %-1.(%)',
            '%2* %Y %*'
        })
    end,
    inactive = function()
        return table.concat({
            '%3* %-3.(%)',
            ' %1* %f %*',
            '%1* %m',
            '%='
        })
    end,
}

-- autocmd({ 'BufWritePost' }, {
--   pattern = '*.lua',
--   desc = 'Reload init.lua on save',
--   callback = reload_config
-- })

autocmd({ 'BufEnter', 'FocusGained', 'VimEnter', 'WinEnter' }, {
    desc = 'Active Statusline',
    callback = function()
        vim.opt_local.statusline = statusline['active']()
    end
})

autocmd({ 'FocusLost', 'WinLeave' }, {
    desc = 'Inactive Statusline',
    callback = function()
        vim.opt_local.statusline = statusline['inactive']()
    end
})

-- Mapping

local map = vim.keymap.set

map('c', '<M-k>', '<Up>')
map('c', '<M-j>', '<Down>')
map('t', '<M-k>', '<Up>')
map('t', '<M-j>', '<Down>')
map('t', '<Esc>', '<C-\\><C-n>')

map('', 'Q', 'gq')               -- Format paragraph
map('i', '<C-U>', '<C-G>u<C-U>') -- Something about undo...

map('i', '{<CR>', '{<CR>}<Esc>ko')
map('i', '{<Space> {', '}<Left><Left>')
map('i', '[<CR>', '[<CR>]<Esc>ko')
map('i', '[<Space> [', ']<Esc>hi')
map('i', '(<CR>', '(<CR>)<Esc>ko')
map('i', '(<Space> (', ')<Esc>hi')
-- handled by tmux plugin
-- map('', '<C-h>', '<C-w>h')
-- map('', '<C-j>', '<C-w>j')
-- map('', '<C-k>', '<C-w>k')
-- map('', '<C-l>', '<C-w>l')

map('n', 'sr', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>')

-- Tabs
map('n', '<C-w><C-w>', ':tabclose<cr>', { silent = true })
map('n', '<C-t>', ':tabnew<cr>', { silent = true })
for i = 1, 10 do
    map('n', '<m-' .. i .. '>', ':tabnext ' .. i .. '<cr>', { silent = true })
    map('i', '<m-' .. i .. '>', '<ESC>:tabn ' .. i .. '<cr>', { silent = true })
end

autocmd('BufWritePre', {
    desc = 'Remove trailing whitespace on save',
    command = '%s/\\s\\+$//e'
})

autocmd('BufWritePre', {
    desc = "Create parent directory if does not exists",
    callback = function(t)
        local dir = vim.fn.fnamemodify(t.file, ':p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end
})

autocmd('BufReadPost', {
    desc = "Restore cursor",
    callback = function()
        vim.fn.setpos(".", vim.fn.getpos("'\""));
    end
})

autocmd({ 'FocusGained', 'BufEnter' }, {
    desc = "Check file changes",
    callback = function()
        vim.cmd(':silent! !')
    end
})

-- Templates
autocmd("BufNewFile", {
    desc = 'Shell template',
    pattern = { '*.sh' },
    callback = function()
        vim.fn.setline('.', '#!/usr/bin/env sh')
        vim.fn.setline(2, '')
        vim.cmd 'normal!j'
    end
})

autocmd('TermOpen', {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end
})

-- autocmd("BufWritePre", {
--     desc = "LSP format on save",
--     callback = function()
--         vim.lsp.buf.format()
--     end,
-- })

function AdaptColorscheme()
    vim.cmd [[
        highlight clear CursorLine
        highlight Normal ctermbg=none guibg=none
        highlight LineNr ctermbg=none guibg=none
        highlight Folded ctermbg=none guibg=none
        highlight NonText ctermbg=none guibg=none
        highlight EndOfBuffer ctermbg=none guibg=none
        highlight SpecialKey ctermbg=none guibg=none
        highlight VertSplit ctermbg=none guibg=none
        highlight SignColumn ctermbg=none guibg=none

        highlight StatusLine cterm=bold gui=bold
        highlight User1 cterm=bold gui=bold
        highlight StatusLineNC cterm=none ctermfg=none gui=none
        highlight VertSplit cterm=none ctermfg=blue guifg=black
        highlight Normal guibg=NONE
        highlight TabLine ctermbg=none guibg=none guifg=#626262
        highlight TabLineFill ctermbg=none guibg=none
        highlight TabLineSel cterm=bold gui=bold ctermbg=none guibg=none ctermfg=1 guifg=#00A8C6
    ]]
end

autocmd("ColorScheme", {
    desc = "Adapt colorscheme",
    callback = AdaptColorscheme,
})
AdaptColorscheme()

vim.api.nvim_create_user_command(
    'Cwd',
    "cd %:p:h",
    { nargs = 0 }
)

-- :map gf :e <cfile><CR>
-- vim.keymap.set('n', 'gf', ':e <cfile><CR>', { silent = true })
vim.keymap.set(
    'n', 'gf',
    function()
        local path = vim.fn.expand('<cfile>')
        if path == '' then
            return
        end

        local ok = pcall(function() vim.cmd "norm!gf" end)

        if ok then
            return
        end

        local new_path = vim.fn.fnamemodify(vim.fn.expand('%:p:h') .. '/' .. path, ':p')
        if vim.fn.fnamemodify(new_path, ':e') ~= '' then
            return vim.cmd('edit ' .. new_path)
        end

        local suffixes = vim.opt.suffixesadd:get()
        if not suffixes then
            return
        end

        for _, suffix in ipairs(suffixes) do
            vim.print(suffix)
            if vim.fn.filereadable(new_path .. suffix) == 1 then
                return vim.cmd('edit ' .. new_path .. suffix)
            end
        end

        return vim.cmd('edit ' .. new_path)
    end,
    { silent = true }
)

function GetRemoteUrl()
  local file_path = vim.fn.expand('%:p')
  local git_dir = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local relative_path = file_path:sub(#git_dir + 2)
  local remote_url = vim.fn.systemlist('git config --get remote.origin.url')[1]
  local branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]

  -- Convert SSH URL to HTTPS URL if necessary
  if remote_url:find('^git@') then
    remote_url = remote_url:gsub('^git@', 'https://')
    remote_url = remote_url:gsub('%.com:', '.com/')
  end

  -- Replace the .git suffix with /blob/branch/relative_path for GitLab URLs
  if remote_url:find('gitlab.com') then
    remote_url = remote_url:gsub('%.git$', '') .. '/blob/' .. branch .. '/' .. relative_path
  end

  return remote_url
end

vim.api.nvim_set_keymap('n', '<leader>gu', ':lua print(GetRemoteUrl())<CR>', { noremap = true, silent = true })
