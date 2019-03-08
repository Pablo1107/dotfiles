
"        ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"        ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"        ██║   ██║██║██╔████╔██║██████╔╝██║     
"        ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"      ██╗╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"      ╚═╝ ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"           Author: Pablo Andres Dealbera
"           Year: 2019

"" Vundle Stuff {{{
set nocompatible              " be iMproved, required
filetype off                  " required

if filereadable(expand('~/.vim/bundle/Vundle.vim/README.md'))
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()

  Plugin 'VundleVim/Vundle.vim'

  " Plugins
  Plugin 'SirVer/ultisnips' " Snippets Manager
  Plugin 'adriaanzon/vim-emmet-ultisnips'
  Plugin 'honza/vim-snippets' " A general collection of snippets
  Plugin 'epilande/vim-react-snippets'
  Plugin 'posva/vim-vue' " VueJS syntax
  Plugin 'junegunn/goyo.vim' " Zen focus
  Plugin 'pangloss/vim-javascript' " Extended VueJS syntax
  Plugin 'mxw/vim-jsx' " JSX syntax
  Plugin 'roman/golden-ratio' " Makes current split bigger
  Plugin 'junegunn/fzf.vim'
  Plugin 'christoomey/vim-tmux-navigator' " Seamless navigation in vim and tmux
  Plugin 'tomtom/tcomment_vim'
  Plugin 'vimwiki/vimwiki'
  Plugin 'suan/vim-instant-markdown' " Live preview vimwiki notes

  " Configuration

  " UltiSnips {{{
  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

  " If you want :UltiSnipsEdit to split your window.
  let g:UltiSnipsEditSplit="vertical"
  " }}}

  call vundle#end()            " required
  filetype plugin indent on    " required
  " Brief help {{{
  " To ignore plugin indent changes, instead use:
  "filetype plugin on
  "
  " :PluginList       - lists configured plugins
  " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
  " :PluginSearch foo - searches for foo; append `!` to refresh local cache
  " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
  "
  " see :h vundle for more details or wiki for FAQ
  " Put your non-Plugin stuff after this line
  " }}}
endif
"" }}}

"" Default vimrc file config {{{

" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Jun 13
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Line numbering
set number
set relativenumber

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

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
    autocmd! BufWritePost $MYVIMRC,$OGVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw | call CustomStyle()
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
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
    autocmd BufWritePost .Xresources silent exec "!xrdb -merge ~/.Xresources" | echom ".Xresources merged"
    autocmd BufWritePost .tmux.conf
      \ if exists('$TMUX') |
          \ silent exec "!tmux source-file ~/.tmux.conf" | echom "Tmux config file re-sourced" |
      \ endif
  augroup END
  " }}}
endif " has autocmd

" Fix for Browser-Sync
set backupcopy=yes

" Undo after closing Vim
if !isdirectory($HOME."/.vim/undo-dir")
  call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
"asdas
"asdasd
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

nnoremap <Tab> za
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
  hi Directory guibg=NONE
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
  hi User1 guifg=#FFFFFF guibg=#191f26
  hi User2 guifg=#000000 guibg=#959ca6
  hi User3 guifg=#00A8C6 guibg=#131920
  hi StatusLine gui=NONE guifg=#FFFFFF guibg=NONE
  hi StatusLineNC gui=reverse guifg=#00A8C6 guibg=#131920
  hi VertSplit guifg=#00A8C6 guibg=#131920
  " }}} 

  " Make 81 character distinct
  hi ColorColumn guibg=#00A8C6
  call matchadd('ColorColumn', '\%81v', 100)

  " Folds Styling
  highlight FoldColumn  gui=bold    guifg=grey65     guibg=#035C9D
  highlight Folded      gui=italic  guifg=#03A1C1      guibg=#035C9D
  "highlight LineNr      gui=NONE    guifg=grey60     guibg=Grey90

  " Terminal Colors
  let g:terminal_ansi_colors = ['#1B2B34', '#EC5f67', '#99C794', '#FAC863', '#6699CC', '#C594C5', '#5FB3B3', '#C0C5CE', '#65737E', '#EC5f67', '#99C794', '#FAC863', '#6699CC', '#C594C5', '#5FB3B3', '#D8DEE9'] 
  hi Terminal guibg=#002B36
endfunction " }}}
autocmd ColorScheme * call CustomStyle()
"source ~/.vim/colors/freshcut.vim
colorscheme freshcut
"colorscheme base16-default-dark
"" }}}

"" Status Line {{{
set laststatus=2
set statusline=
set statusline+=%2*\ %l
set statusline+=\ %*
set statusline+=%1*\ 
set statusline+=%3*\ ৰ\  
set statusline+=%1*\ %f\ %*
set statusline+=%1*\ %m
"set statusline+=%3*\ %F
set statusline+=%=
set statusline+=%1*Tab:
set statusline+=%3*\ %{&tabstop}\ 
set statusline+=%3*%-3.(%V%)
set statusline+=%1*Line:
set statusline+=%3*\ %l,%c\ 
set statusline+=%3*%-3.(%V%)
set statusline+=%1*FileType: 
set statusline+=%3*\ %Y\ 
"" }}}

"" External Plugins Configuration {{{
" fzf plugin
set rtp+=~/.fzf
nnoremap <C-P> :FZF <Enter>
if !has('nvim')
  execute "set <M-p>=\ep"
endif
nnoremap <M-p> :Ag <Enter>
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
nnoremap <S-F> :call ToggleNetrw()<CR>
hi netrwDir guifg=#00A8C6
"" }}}

"" Mapping {{{

" General Mapping
inoremap {<CR> {<CR>}<Esc>ko
nnoremap Ñ <C-^>
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
else
  tnoremap <Esc> <C-\><C-n>
endif

" Maximize Split {{{
nnoremap <C-W>O :call MaximizeToggle()<CR>
nnoremap <C-W>o :call MaximizeToggle()<CR>
nnoremap <C-W><C-O> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction
" }}}
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
  tnoremap <silent> <C-h> <C-W>:TmuxNavigateLeft<CR>
  tnoremap <silent> <C-j> <C-W>:TmuxNavigateDown<CR>
  tnoremap <silent> <C-k> <C-W>:TmuxNavigateUp<CR>
  tnoremap <silent> <C-l> <C-W>:TmuxNavigateRight<CR>
endif
"" }}}
