set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
let $OGVIMRC=expand('~/.vimrc')
source $OGVIMRC
