
"        ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"        ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"        ██║   ██║██║██╔████╔██║██████╔╝██║     
"        ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"      ██╗╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"      ╚═╝ ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"           Author: Pablo Andres Dealbera
"           Year: 2019

"" vim-plug Stuff {{{
if filereadable(expand('~/.vim/autoload/plug.vim'))
  " Specify a directory for plugins
  " - For Neovim: ~/.local/share/nvim/plugged
  " - Avoid using standard Vim directory names like 'plugin'
  call plug#begin('~/.vim/plugged')

  " Plugins
  Plug 'SirVer/ultisnips' " Snippets Manager
  Plug 'adriaanzon/vim-emmet-ultisnips'
  Plug 'honza/vim-snippets' " A general collection of snippets
  Plug 'epilande/vim-react-snippets'
  Plug 'posva/vim-vue', { 'for': 'vue' } " VueJS syntax
  Plug 'junegunn/goyo.vim' " Zen focus
  Plug 'pangloss/vim-javascript' " Improved Javascript indentation and syntax support
  Plug 'mxw/vim-jsx', { 'for': 'javascript' } " JSX syntax
  Plug 'roman/golden-ratio' " Makes current split bigger
  Plug 'christoomey/vim-tmux-navigator' " Seamless navigation in vim and tmux
  Plug 'tomtom/tcomment_vim'
  " Plug 'vimwiki/vimwiki'
  " Plug 'suan/vim-instant-markdown' " Live preview vimwiki notes
  Plug 'tpope/vim-eunuch' " Helpers for UNIX (Move, Rename, etc)
  " Plug 'ludovicchabant/vim-gutentags' " manages your tag files
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " A command-line fuzzy finder 
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-fugitive'
  Plug 'neomake/neomake'
  " prettier {{{
  Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/1.x',
  \ 'for': [
    \ 'javascript',
    \ 'typescript',
    \ 'css',
    \ 'less',
    \ 'scss',
    \ 'json',
    \ 'graphql',
    \ 'markdown',
    \ 'vue',
    \ 'lua',
    \ 'php',
    \ 'python',
    \ 'ruby',
    \ 'html',
    \ 'swift' ] }
  " }}}
  Plug 'Pablo1107/codi.vim'
  Plug 'rainglow/vim'
  Plug 'tpope/vim-repeat'
  if has('nvim')
    Plug 'neoclide/jsonc.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  endif

  call plug#end()

  " Configuration

  " coc.nvim {{{
  if match(&rtp, 'coc.nvim') != -1
    let g:coc_global_extensions = [
      \ 'coc-tsserver',
      \ 'coc-phpls',
      \ 'coc-prettier',
      \ ]
    command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    inoremap <silent><expr> <C-n>
      \ pumvisible() ? "\<C-n>" :
      \ coc#refresh()
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gp <Plug>(coc-format)
  endif
  " }}}

  " UltiSnips {{{
  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"

  " Load HTML snippets on JSX files
  autocmd FileType javascript.jsx UltiSnipsAddFiletypes html
  " }}}

  " VimWiki {{{
    let g:vimwiki_global_ext = 0
    let g:vimwiki_table_mappings = 0
    let g:vimwiki_list = [{'path': '~/vimwiki/',
                       \ 'syntax': 'markdown', 'ext': '.md'}]
    let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
  " }}}
  
  let g:instant_markdown_autostart = 0

  " Prettier {{{
  " max line length that prettier will wrap on
  " Prettier default: 80
  " let g:prettier#config#print_width = 80

  " number of spaces per indentation level
  " Prettier default: 2
  " let g:prettier#config#tab_width = 2

  " use tabs over spaces
  " Prettier default: false
  " let g:prettier#config#use_tabs = 'false'

  " print semicolons
  " Prettier default: true
  let g:prettier#config#semi = 'false'

  " single quotes over double quotes
  " Prettier default: false
  let g:prettier#config#single_quote = 'true'

  " print spaces between brackets
  " Prettier default: true
  " let g:prettier#config#bracket_spacing = 'true'

  " put > on the last line instead of new line
  " Prettier default: false
  " let g:prettier#config#jsx_bracket_same_line = 'true'

  " avoid|always
  " Prettier default: avoid
  let g:prettier#config#arrow_parens = 'always'

  " none|es5|all
  " Prettier default: none
  let g:prettier#config#trailing_comma = 'es5'

  " flow|babylon|typescript|css|less|scss|json|graphql|markdown
  " Prettier default: babylon
  " let g:prettier#config#parser = 'flow'

  " cli-override|file-override|prefer-file
  " let g:prettier#config#config_precedence = 'prefer-file'

  " always|never|preserve
  " let g:prettier#config#prose_wrap = 'preserve'

  " css|strict|ignore
  " let g:prettier#config#html_whitespace_sensitivity = 'css'
  " }}}

  " Neomake {{{
    call neomake#configure#automake('nw', 750)
  " }}}

  " fzf {{{
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

  augroup fzf
    autocmd!
    autocmd FileType fzf set laststatus=0 noshowmode noruler nonumber norelativenumber
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler number relativenumber
    autocmd FileType fzf tnoremap <buffer> <esc> <c-c>
  augroup END
  " }}}

  if !has('nvim')
    execute "set <M-p>=\ep"
  endif

  " fzf customization {{{
  command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
  " }

endif
"" }}}

" }}}

"" Default vimrc file config {{{

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

set history=200		" keep 200 lines of command line history

set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Line numbering
set number
set relativenumber

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  if exists("syntax_on")
    syntax reset
  else
    syntax on
  endif
  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif
" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim80/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" do not load defaults if ~/.vimrc is missing
"let skip_defaults_vim=1
"" }}}

"" Vim Settings {{{
if &term =~# '^screen'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if has ('autocmd') " Remain compatible with earlier versions
  " Auto-reload .vimrc on save {{{
  augroup vimrc     " Source vim configuration upon save
    autocmd!
    autocmd BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw | call CustomStyle()
    autocmd BufWritePost $OGVIMRC source % | echom "Reloaded " . $OGVIMRC | redraw | call CustomStyle()
    autocmd BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
  " }}}

  " Mkdir when creating a file {{{
  augroup Mkdir
    autocmd!
    autocmd BufWritePre *
      \ if !isdirectory(expand("<afile>:p:h")) |
          \ call mkdir(expand("<afile>:p:h"), "p") |
      \ endif
  augroup END
  " }}}

  " autocmd when saving different files {{{
  augroup SaveFileAnd
    autocmd!
    autocmd BufWritePost .Xresources silent exec "!xrdb -merge ~/.Xresources" | echom ".Xresources merged"
    autocmd BufWritePost .tmux.conf
      \ if exists('$TMUX') |
          \ silent exec "!tmux source-file ~/.tmux.conf" | echom "Tmux config file re-sourced" |
      \ endif
    autocmd BufWritePre *.js,*.jsx,*.ts,*.php :%s/\s\+$//e
  augroup END
  " }}}

  " autocmd when opening different files {{{
  augroup OpenFileAnd
    autocmd!
    autocmd BufReadPost *.js,*.jsx,*.ts call map({
          \ "'r": '\v<render> *(\=)? *\(\) *(\=\>)? *\{',
          \ "'s": 'this.state.*=.*{',
          \ }, { mark, pattern ->
          \   setpos(
          \     mark,
          \     extend([expand("<abuf>"), 0],
          \     searchpos(pattern, 'n'), 1)
          \   )
          \ })
  augroup END
  " }}}

  " Terminal Settings {{{
  augroup TerminalSettings
    autocmd!
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber
    autocmd TermOpen * startinsert
    autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
  augroup END
  " }}}
endif " has autocmd

" Read files when change outside vim
set autoread

" Fix for Browser-Sync
set backupcopy=yes

" Undo after closing Vim
if !isdirectory($HOME."/.vim/undo-dir")
  call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
"" }}}

"" Folds {{{
" Set a nicer foldtext function
set foldtext=MyFoldText()
function! MyFoldText() " {{{
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let linenum = v:foldstart + 1
    while linenum < v:foldend
      let line = getline( linenum )
      let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
      if comment_content != ''
        break
      endif
      let linenum = linenum + 1
    endwhile
    let sub = initial . ' ' . comment_content
  else
    let sub = line
    let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
      endif
    endif
  endif
  let n = v:foldend - v:foldstart + 1
  let info = " " . n . " lines"
  let sub = sub . "                                                                                                                  "
  let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
  let fold_w = getwinvar( 0, '&foldcolumn' )
  let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
  return sub . info
endfunction " }}}

autocmd FileType vim setlocal foldmethod=marker
autocmd FileType vim setlocal foldlevel=0
autocmd FileType tmux setlocal foldmethod=marker
autocmd FileType tmux setlocal foldlevel=0
"" }}}

"" Theme {{{
set termguicolors
function! CustomStyle() abort " {{{
  " Transparent bg everything! {{{
  hi Cursor guibg=NONE
  hi Normal guibg=NONE
  hi NonText guibg=NONE
  hi Visual guibg=#035C9D
  hi Linenr guibg=NONE
  hi Directory guibg=NONE guifg=#035C9D
  hi IncSearch guibg=NONE
  hi SpecialKey guibg=NONE
  hi Titled guibg=NONE
  hi ErrorMsg guibg=NONE
  hi ModeMsg guibg=NONE
  hi Question guibg=NONE
  hi StatusLine guibg=NONE
  hi StatusLineNC guibg=NONE
  hi VertSplit guibg=NONE
  hi DiffAdd guibg=NONE
  hi DiffChange guibg=NONE
  hi DiffDelete guibg=NONE
  hi DiffText guibg=NONE
  hi Comment guibg=NONE guifg=LightGrey
  hi Constant guibg=NONE
  hi String guibg=NONE
  hi Character guibg=NONE
  hi Number guibg=NONE
  hi Boolean guibg=NONE
  hi Float guibg=NONE
  hi Identifier guibg=NONE
  hi Function guibg=NONE
  hi Statement guibg=NONE
  hi Conditional guibg=NONE
  hi Repeat guibg=NONE
  hi Label guibg=NONE
  hi Operator guibg=NONE
  hi Keyword guibg=NONE
  hi Exception guibg=NONE
  hi PreProc guibg=NONE
  hi Include guibg=NONE
  hi Type guibg=NONE
  hi StorageClass guibg=NONE
  hi Structure guibg=NONE
  hi Typedef guibg=NONE
  hi Special guibg=NONE
  hi SpecialChar guibg=NONE
  hi Tag guibg=NONE
  hi Delimiter guibg=NONE
  hi SpecialComment guibg=NONE
  hi Debug guibg=NONE
  hi Underlined guibg=NONE
  hi Title guibg=NONE
  hi Ignore guibg=NONE
  hi Error guibg=NONE
  hi Todo guibg=NONE
  hi htmlH2 guibg=NONE
  hi Pmenu guifg=fg guibg=#002B36
  hi StatusLine cterm=NONE guifg=fg
  " }}}
  
  " Status Line colors {{{
  hi User1 guifg=#FFFFFF guibg=#191f26 " Normal text
  hi User2 guifg=#000000 guibg=#00A8C6 " Accent section
  hi User3 guifg=#00A8C6 guibg=#131920 " Non-accent section

  hi User4 guifg=#00A8C6 guibg=#191f26 " Accent arrow to normal background
  hi User6 guifg=#00A8C6 guibg=#131920 " Accent arrow to non-accent background
  hi User5 guifg=#131920 guibg=#191f26 " Normal arrow to accent background
  hi User7 guifg=#131920 guibg=#00A8C6  " Non-accent arrow to accent background
  hi User8 guifg=#131920 guibg=#191f26  " Non-accent arrow to normal background
  hi StatusLine gui=NONE guifg=#FFFFFF guibg=NONE
  hi StatusLineNC gui=reverse guifg=#00A8C6 guibg=#131920
  hi VertSplit guifg=#00A8C6 guibg=#131920
  " }}} 

  " Make 81 character distinct
  hi ColorColumn guibg=#00A8C6
  call matchadd('ColorColumn', '\%81v', 100)

  " Folds Styling
  highlight FoldColumn  gui=bold    guifg=grey65     guibg=#035C9D
  highlight Folded      gui=italic  guifg=#03A1C1    guibg=#035C9D
  "highlight LineNr     gui=NONE    guifg=grey60     guibg=Grey90

  " Tabs Bar
  highlight! link TabLineFill User5
  highlight! link TabLine User3
  highlight! link TabLineSel User2
  highlight! link Title User2

  " Terminal Colors
  if has('nvim')
    let g:terminal_color_0  = '#1B2B34'
    let g:terminal_color_1  = '#EC5f67'
    let g:terminal_color_2  = '#99C794'
    let g:terminal_color_3  = '#FAC863'
    let g:terminal_color_4  = '#6699CC'
    let g:terminal_color_5  = '#C594C5'
    let g:terminal_color_6  = '#5FB3B3'
    let g:terminal_color_7  = '#C0C5CE'
    let g:terminal_color_8  = '#65737E'
    let g:terminal_color_9  = '#EC5f67'
    let g:terminal_color_10 = '#99C794'
    let g:terminal_color_11 = '#FAC863'
    let g:terminal_color_12 = '#6699CC'
    let g:terminal_color_13 = '#C594C5'
    let g:terminal_color_14 = '#5FB3B3'
    let g:terminal_color_15 = '#D8DEE9'
  endif
  " let g:terminal_ansi_colors = ['#1B2B34', '#EC5f67', '#99C794', '#FAC863', '#6699CC', '#C594C5', '#5FB3B3', '#C0C5CE', '#65737E', '#EC5f67', '#99C794', '#FAC863', '#6699CC', '#C594C5', '#5FB3B3', '#D8DEE9'] 
  hi Terminal guibg=#002B36

  " Neomake
  hi SignColumn guifg=#03A1C1 guibg=NONE
endfunction " }}}
augroup Colors
  autocmd!
  autocmd ColorScheme * call CustomStyle()
augroup END
"source ~/.vim/colors/freshcut.vim
colorscheme freshcut
"colorscheme base16-default-dark
"" }}}

"" Status Line {{{
set laststatus=2

func! FocusStatusline()
  let l:focus=''
  let l:focus.='%2*\ %l'
  let l:focus.='%2*\ %6*'
  let l:focus.='%3*\ %c'
  let l:focus.='%3*\ %7*'
  let l:focus.='\ %*'
  let l:focus.='%<'
  let l:focus.='%2*ৰ'
  let l:focus.='%2*\ %4*'
  let l:focus.='\ %1*\ %f\ %*'
  let l:focus.='%1*\ %m'
  let l:focus.='%='

  if strlen(fugitive#head())
    let l:focus.='%6*'
    let l:focus.='%2*\ '
    let l:focus.='\ %{fugitive#head()}'
    let l:focus.='%7*\ '
  else
    let l:focus.='%8*\ '
  endif

  let l:focus.='%3*\ %-1.(%)'
  let l:focus.='%3*Tab:\ %{&tabstop}'
  let l:focus.='%3*\ %-1.(%)'
  let l:focus.='%6*'
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

"" }}}

"" Templates {{{
augroup templates
" Bash Scripts
  autocmd BufNewFile *.sh call SetBashTemplate()
  function! SetBashTemplate() 
	  0r ~/.vim/templates/skeleton.sh
	  normal!j
  endfunction
" HTML
  autocmd BufNewFile *.html call SetHTMLTemplate()
  function! SetHTMLTemplate() 
	  0r ~/.vim/templates/skeleton.html
  endfunction
" React/Styled-Components file
  autocmd BufNewFile */Styled/index.js call SetStyledTemplate()
  function! SetStyledTemplate() 
	  0r ~/.vim/templates/skeleton.styled
  endfunction
augroup END
"" }}}

"" netrw file manager {{{
" remove banner
let g:netrw_banner = 0
" open file in previous window
let g:netrw_browse_split = 4
" window size to 25%
let g:netrw_winsize = 25
let g:netrw_liststyle = 3

let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction
hi netrwDir guifg=#00A8C6
"" }}}

"" Mapping {{{

" General Mapping
let mapleader = ","

inoremap {<CR> {<CR>}<Esc>ko
inoremap [<CR> [<CR>]<Esc>ko
nnoremap <Space>j <C-D>
nnoremap <Space>k <C-U>
" nnoremap <Leader>s :%s/\<<c-r><c-w>\>//g<left><left>
nnoremap <Leader>s :call Styled()<CR>
nnoremap <Leader>p <C-^>
nnoremap <Leader>f :call ToggleNetrw()<CR>
inoremap <expr> <Leader>f GlobalLineCompletion()
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader><Leader> za
nmap <Leader>y <Plug>(Prettier)
nnoremap <C-P> :FZF <Enter>
nnoremap <M-p> :Ag <Enter>
set pastetoggle=<F2>
map <F3> "+y
noremap <F7> mzgg=G`z
noremap <silent> <F8> :silent call EnterGoyo()<CR>
func! EnterGoyo()
  echo "hola"
  set notermguicolors
  execute "normal \<Plug>(golden_ratio_toggle)"
  hi StatusLineNC NONE
  hi VertSplit NONE
  Goyo
  set termguicolors
endfunc

func! GlobalLineCompletion()
  execute fzf#vim#complete(fzf#wrap({
    \ 'prefix': '^.*$',
    \ 'source': 'rg -n ^ --color always',
    \ 'options': '--ansi --delimiter : --nth 3..',
    \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') } }))
  return ''
endfunc

func! Styled()
  if &filetype == 'javascript.jsx'
    execute "edit " . expand("%:h") . "/components/Styled/index.js"
  endif
endfunc
  
func! NewComponent(name)
  execute "edit " . expand("%:h") . "/components/" . a:name . "/index.js"
endfunc

command! -nargs=* NewComponent :call NewComponent(<q-args>)
" Mapping for HTML
autocmd BufRead,BufNewFile *.blade.php set filetype=html
"autocmd FileType html inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
"autocmd FileType html inoremap ;i <em></em><Esc>FeT>
"autocmd FileType html inoremap ;a <a href=""></a><Esc>F"i
"autocmd FileType html inoremap <div><CR> <div><CR></div><Esc>ko
"autocmd FileType html inoremap <form><CR> <form><CR></form><Esc>ko
"autocmd FileType html inoremap <input><CR> <input type="text" name="" placeholder=""><++></input><++><Esc>F"i
autocmd FileType html iabbrev </ </<C-X><C-O>
autocmd FileType html inoremap <lt>/ </<C-x><C-o><Esc>==gi

" Mapping for Terminal
if !has('nvim')
  tnoremap <Esc> <C-W>N
  tnoremap <Esc><Esc> <C-W>N
  set timeout timeoutlen=1000  " Default
  set ttimeout ttimeoutlen=100  " Set by defaults.vim
else
  tnoremap <Esc> <C-\><C-n>
endif
"" }}}

"" Tab Sizing {{{
set listchars=tab:►-,eol:¬,trail:●
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=0
" when indenting with '>', use 2 spaces width
set shiftwidth=0
"let &shiftwidth=&tabstop

func! SetTabSize(size)
  let &tabstop=a:size
endfunc

autocmd FileType html call SetTabSize(2) 
autocmd FileType css call SetTabSize(2) 
autocmd FileType javascript call SetTabSize(2) 
autocmd FileType php call SetTabSize(4) 
autocmd FileType lua call SetTabSize(4) 
"" }}}

"" Splits {{{
set splitbelow splitright
if match(&rtp, 'vim-tmux-navigator') == -1
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif
if match(&rtp, 'vim-tmux-navigator') != -1
  tnoremap <silent> <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-\><C-n>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-\><C-n>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-\><C-n>:TmuxNavigateRight<CR>
  tnoremap <silent> <C-w> <C-\><C-n><C-w>
endif
"" }}}
