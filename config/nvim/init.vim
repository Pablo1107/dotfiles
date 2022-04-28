
"      ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
"      ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
"      ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
"      ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
"      ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
"      ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
"           Author: Pablo Andres Dealbera
"           Year: 2020

let plugin_on = 0
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
  call plug#begin('~/.config/nvim/plugged')

  Plug 'sheerun/vim-polyglot'
  " Plug 'tomtom/tcomment_vim'
  Plug 'terrortylor/nvim-comment'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  " Plug 'junegunn/fzf'
  " Plug 'junegunn/fzf.vim'
  Plug 'vifm/vifm.vim'
  Plug 'tpope/vim-eunuch' " Helpers for UNIX (Move, Rename, etc)
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'machakann/vim-sandwich'
  Plug 'christoomey/vim-tmux-navigator' " Seamless navigation in vim and tmux
  " Plug 'roman/golden-ratio' " Makes current split bigger
  " Plug 'lervag/vimtex'
  " Plug 'vimwiki/vimwiki'
  " Plug 'nathangrigg/vim-beancount'
  " Plug 'Pablo1107/codi.vim'
  Plug 'ap/vim-css-color'
  " coc.nvim
  Plug 'neoclide/jsonc.vim'
  " Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Plug 'SirVer/ultisnips'
  " Plug 'honza/vim-snippets'
  " Plug 'epilande/vim-react-snippets'
  " Plug 'tpope/vim-dispatch'
  Plug 'ghifarit53/tokyonight-vim'
  " Plug 'folke/tokyonight.nvim'
  " Plug 'Pablo1107/codi.vim'
  " Plug 'arecarn/vim-crunch'

  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-compe'
  Plug 'RishabhRD/popfix'
  Plug 'RishabhRD/nvim-lsputils'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'shaunsingh/solarized.nvim'
  " Plug 'jose-elias-alvarez/nvim-lsp-ts-utils', { 'branch': 'main' }
  " Plug 'prettier/vim-prettier', {
  " \ 'do': 'yarn install',
  " \ 'branch': 'release/0.x'
  " \ }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'folke/trouble.nvim'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'romgrk/nvim-treesitter-context'
  Plug 'nvim-treesitter/playground'
  Plug 'lervag/wiki.vim'
  Plug 'sindrets/diffview.nvim'
  Plug 'luukvbaal/stabilize.nvim'
  Plug 'github/copilot.vim'
  Plug 'nathangrigg/vim-beancount'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'elkowar/yuck.vim'
  Plug 'eraserhd/parinfer-rust', {'do':
        \  'cargo build --release'}

  call plug#end()

  let plugin_on = 1

  if match(&rtp, 'fzf.vim') != -1
    command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
  endif

  runtime macros/sandwich/keymap/surround.vim
endif


set history=10000
set ttimeoutlen=100 " wait up to 100ms after Esc for special key
set number
set relativenumber
set display=truncate
set scrolloff=5
set autoread " read files when change outside vim
set backupcopy=yes
set mouse=n
set spelllang=en_us,es
set complete+=kspell
set viminfo+=n~/.cache/vim/viminfo
set inccommand=nosplit
set ignorecase
set smartcase

" Tab Sizing
set listchars=tab:►-,eol:¬,trail:●
set expandtab " on pressing tab, insert 2 spaces
set tabstop=2 " show existing tab with 2 spaces width
set softtabstop=0
set shiftwidth=0 " when indenting with '>', use tabstop config

function! SetTabSize(size)
  let &tabstop=a:size
endfunction

autocmd FileType html call SetTabSize(2) 
autocmd FileType css call SetTabSize(2) 
autocmd FileType javascript call SetTabSize(2) 
autocmd FileType python call SetTabSize(4) 
autocmd FileType php call SetTabSize(4) 
autocmd FileType lua call SetTabSize(4) 
autocmd FileType c call SetTabSize(4) 

" Splits
set splitright
set splitbelow

" Variables
if plugin_on
  if match(&rtp, 'vimwiki') != -1
    let g:vimwiki_list = [{
    \ 'path': '~/wiki/',
    \ 'syntax': 'markdown', 
    \ 'ext': '.md' }]
  endif
  
  if match(&rtp, 'wiki.vim') != -1
    let g:wiki_root = '~/wiki'
    let g:wiki_link_extension = '.md'
    let g:wiki_filetypes = ['md']

    let g:wiki_file_handler = 'WikiFileHandler'

    function! WikiFileHandler(...) abort dict
      if self.path =~# 'pdf$'
        silent execute '!zathura' fnameescape(self.path) '&'
        return 1
      endif

      return 0
    endfunction
  endif

  if match(&rtp, 'vimtex') != -1
    let g:tex_flavor='latex'
    let g:vimtex_view_method = 'zathura'
    let g:vimtex_quickfix_mode=0
    set conceallevel=1
    let g:tex_conceal='abdmg'
  endif

  " if match(&rtp, 'coc.nvim') != -1
  "   let g:coc_global_extensions = [
  "   \ 'coc-tsserver',
  "   \ 'coc-json',
  "   \ 'coc-ultisnips',
  "   \]
  " endif

  if match(&rtp, 'ultisnips') != -1
    " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<tab>"
    " let g:UltiSnipsJumpForwardTrigger="<c-b>"
    " let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    "
    " " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit="horizontal"
    let g:vimwiki_table_mappings=0
  endif
endif

" Undo after closing Vim
if !isdirectory($HOME."/.config/nvim/undo-dir")
  call mkdir($HOME."/.config/nvim/undo-dir", "", 0700)
endif
set undodir=~/.config/nvim/undo-dir
set undofile

if has('win32') || has ('win64')
  let $VIMHOME=$VIM."/vimfiles"
else
  let $VIMHOME=$HOME."/.config/nvim"
endif

inoremap <C-U> <C-G>u<C-U> " allow undu on <C-U>

" Enable syntax highlighting
if &t_Co > 2 || has("gui_running")
  if exists("syntax_on")
    syntax reset
  else
    syntax on
  endif
  let c_comment_strings=1
endif
filetype plugin indent on

" Autocommands
if has ('autocmd')

  if plugin_on
    if match(&rtp, 'fzf') != -1
      augroup fzf
        autocmd!
        autocmd FileType fzf set laststatus=0 noshowmode noruler nonumber norelativenumber
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler number relativenumber
        autocmd FileType fzf tnoremap <buffer> <esc> <c-c>
      augroup END
    endif
  endif

  augroup ReloadVimrcOnSave " Source vim configuration upon save
    autocmd!
    autocmd BufWritePost $MYVIMRC source %
    if has('nvim')
      autocmd BufWritePost $OGVIMRC source %
    endif
  augroup END

  augroup Mkdir
    autocmd!
    autocmd BufWritePre *
      \ if !isdirectory(expand("<afile>:p:h")) |
          \ call mkdir(expand("<afile>:p:h"), "p") |
      \ endif
  augroup END

  augroup JumpLastPosition " jump to the last known cursor position.
    autocmd!
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
  augroup END

  augroup CheckFileChanges
    autocmd!
    autocmd FocusGained,BufEnter * :silent! !
  augroup END

  if !isdirectory($HOME."/.config/nvim/sessions")
    call mkdir($HOME."/.config/nvim/sessions", "", 0700)
  endif
  let $LASTSESSIONFILE=$VIMHOME."/sessions/last.vim"
  augroup SaveLastSession
    autocmd!
    autocmd VimLeave * :mksession! $LASTSESSIONFILE
  augroup END

  " When loading filetypes
  augroup FileTypeSpecific
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <Leader>s :call Styled()<CR>
  augroup END

  augroup SaveFileAnd
    autocmd!
    autocmd BufWritePost *.rasi silent exec "!rofi -show drun -theme desktop"
    autocmd BufWritePre *.js,*.jsx,*.ts,*.php :%s/\s\+$//e
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.nix lua vim.lsp.buf.formatting_seq_sync(nil, 160)
  augroup END

  augroup OpenFileAnd
    autocmd!
    autocmd BufNewFile,BufRead *.rasi set filetype=css
  augroup END

  augroup Templates
    autocmd!
    " Shell Scripts
    autocmd BufNewFile *.sh call SetBashTemplate()
    " " HTML
    " autocmd BufNewFile *.html call SetHTMLTemplate()
    " function! SetHTMLTemplate() 
    "   0r ~/.vim/templates/skeleton.html
    " endfunction
    " " React/Styled-Components file
    " autocmd BufNewFile */Styled/index.js call SetStyledTemplate()
    " function! SetStyledTemplate() 
    "   0r ~/.vim/templates/skeleton.styled
    " endfunction
  augroup END

  " augroup FocusBuffer
  "   autocmd!
  "   autocmd WinEnter * ownsyntax
  "   autocmd WinLeave * syntax region Dim start='' end='$$$end$$$'
  " augroup END

  augroup TerminalStuff
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
  augroup END

  function! SetBashTemplate() 
    call setline('.', '#!/usr/bin/env sh')
    call setline(2, '')
    normal!j
  endfunc

  function! Styled()
    execute "edit " . expand("%:h") . "/components/Styled/index.js"
  endfunc
endif " has autocmd

function! SynStack() " echo what highlight group the cursor is one
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Mapping
let mapleader = ","

if plugin_on
  if match(&rtp, 'fzf') != -1
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

    nnoremap <C-P> :FZF <Enter>
    nnoremap <M-p> :Ag <Enter>
    nnoremap <Leader>b :Buffers<CR>
    nnoremap <Leader>h :History<CR>
  endif

  if match(&rtp, 'telescope') != -1
    nnoremap <C-P> <cmd>Telescope find_files<cr>
    nnoremap <M-p> <cmd>Telescope live_grep<cr>
    nnoremap <Leader>b <cmd>Telescope buffers<cr>
    nnoremap <Leader>h <cmd>Telescope oldfiles<cr>
    nnoremap <Leader>H <cmd>Telescope help_tags<cr>
  endif

  if match(&rtp, 'coc.nvim') != -1
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " inoremap <silent><expr> <Tab>
    "   \ pumvisible() ? "\<C-n>" :
    "   \ <SID>check_back_space() ? "\<Tab>" :
    "   \ coc#refresh()
    nnoremap <silent> gd <Plug>(coc-definition)
    nnoremap <silent> gp <Plug>(coc-format)
  endif

  if match(&rtp, 'nvim-lspconfig') != -1
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
    " nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> [d <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
    nnoremap <silent> ]d <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
  endif

  if match(&rtp, 'nvim-compe') != -1
    let g:compe = {}
    let g:compe.enabled = v:true
    let g:compe.autocomplete = v:true
    let g:compe.debug = v:false
    let g:compe.min_length = 1
    let g:compe.preselect = 'enable'
    let g:compe.throttle_time = 80
    let g:compe.source_timeout = 200
    let g:compe.incomplete_delay = 400
    let g:compe.max_abbr_width = 100
    let g:compe.max_kind_width = 100
    let g:compe.max_menu_width = 100
    let g:compe.documentation = v:true

    let g:compe.source = {}
    let g:compe.source.path = v:true
    let g:compe.source.buffer = v:true
    let g:compe.source.nvim_lsp = v:true
    let g:compe.source.nvim_lua = v:true
    let g:compe.source.luasnip = v:false
    let g:compe.source.vsnip = v:false
    let g:compe.source.emoji = v:false
    let g:compe.source.calc = v:false
    let g:compe.source.tags = v:false
    let g:compe.source.snippets_nvim = v:false
    let g:compe.source.nvim_treesitter = v:false
    set completeopt=menuone,noselect
    inoremap <silent><expr> <CR> compe#confirm('<CR>')
  endif

  if match(&rtp, 'vifm.vim') != -1
    nnoremap <Leader>f :let g:vifm_embed_split = 1\|vertical topleft 40Vifm\|let g:vifm_embed_split = 0<CR>
    nnoremap <Leader>F :Vifm<CR>
  endif
endif

cnoremap <M-k> <Up>
cnoremap <M-j> <Down>
if has('nvim')
  tnoremap <M-k> <Up>
  tnoremap <M-j> <Down>
  tnoremap <Esc> <C-\><C-n>
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

inoremap {<CR> {<CR>}<Esc>ko
inoremap {<Space> {  }<Left><Left>
inoremap [<CR> [<CR>]<Esc>ko
inoremap [<Space> [  ]<Esc>hi
inoremap (<CR> (<CR>)<Esc>ko
inoremap (<Space> (  )<Esc>hi
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap sr :%s/\<<C-r><C-w>\>//g<Left><Left>

noremap <silent><C-w><C-w> :tabclose<cr>
noremap <silent><C-t> :tabnew<cr>
noremap <silent><m-1> :tabnext 1<cr>
noremap <silent><m-2> :tabnext 2<cr>
noremap <silent><m-3> :tabnext 3<cr>
noremap <silent><m-4> :tabnext 4<cr>
noremap <silent><m-5> :tabnext 5<cr>
noremap <silent><m-6> :tabnext 6<cr>
noremap <silent><m-7> :tabnext 7<cr>
noremap <silent><m-8> :tabnext 8<cr>
noremap <silent><m-9> :tabnext 9<cr>
noremap <silent><m-0> :tabnext 10<cr>
inoremap <silent><m-1> <ESC>:tabn 1<cr>
inoremap <silent><m-2> <ESC>:tabn 2<cr>
inoremap <silent><m-3> <ESC>:tabn 3<cr>
inoremap <silent><m-4> <ESC>:tabn 4<cr>
inoremap <silent><m-5> <ESC>:tabn 5<cr>
inoremap <silent><m-6> <ESC>:tabn 6<cr>
inoremap <silent><m-7> <ESC>:tabn 7<cr>
inoremap <silent><m-8> <ESC>:tabn 8<cr>
inoremap <silent><m-9> <ESC>:tabn 9<cr>
inoremap <silent><m-0> <ESC>:tabn 10<cr>

set termguicolors
let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
let g:tokyonight_disable_italic_comment = 1

function! AdaptColorscheme() abort
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
endfunction

augroup Colors
  autocmd!
  autocmd ColorScheme * call AdaptColorscheme()
augroup END

colorscheme tokyonight
call AdaptColorscheme()

" Status Line
set laststatus=2

func! FocusStatusline()
  let l:focus=''
  " let l:focus.='\ %*'
  let l:focus.='%<'
  let l:focus.='%2*ৰ'
  let l:focus.='\ %1*\ %f\ %*'
  let l:focus.='%1*\ %m'
  let l:focus.='%='

  if strlen(fugitive#head())
    let l:focus.='%2*\ '
    let l:focus.='\ %{fugitive#head()}'
  endif

  let l:focus.='%3*\ %-1.(%)'
  let l:focus.='%3*T%{&tabstop}'
  let l:focus.='%2*\ L%l'
  let l:focus.='%3*\ C%c'
  let l:focus.='%3*\ %-1.(%)'
  let l:focus.='%2*\ %Y\ %*'
  execute 'setlocal statusline='.l:focus
endfunc

func! BlurStatusline()
  let l:blur=''
  let l:blur.='%3*\ %-3.(%)'
  let l:blur.='\ %1*\ %f\ %*'
  let l:blur.='%1*\ %m'
  let l:blur.='%='
  execute 'setlocal statusline='.l:blur
endfunc

if has('statusline')
  autocmd BufEnter,FocusGained,VimEnter,WinEnter * call FocusStatusline()
  autocmd FocusLost,WinLeave * call BlurStatusline()
endif

function! FileTypeMappings()
  execute "edit " . $VIMHOME . "/ftplugin/" . &filetype . "_mappings.vim"
endfunction
command! -nargs=* FileTypeMappings call FileTypeMappings()

" command! -nargs=0 Prettier :CocCommand prettier.formatFile
luafile ~/.config/nvim/lua/lsp.lua

" execute "normal :Copilot disable<cr>"
