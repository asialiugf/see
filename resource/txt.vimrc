set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'Chiel92/vim-autoformat'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'Valloric/YouCompleteMe'
Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"set nocompatible " Use Vim defaults (much better!)
set bs=2  " allow backspacing over everything in insert mode
set ai   " always set autoindenting on
"set backup  " keep a backup file
set viminfo='20,\"50 " read/write a .viminfo file, don't store more
" than 50 lines of registers
set history=50  " keep 50 lines of command line history
set ruler  " show the cursor position all the time

execute pathogen#infect()
syntax on
set nohls
set hlsearch
set incsearch
set tabstop=4
set autoindent
set cindent
set confirm
set nonumber
set expandtab
set autoindent
set smartindent
filetype indent on
"filetype plugin indent on
set syn=cpp
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
hi Identifier cterm=NONE
hi Comment cterm=NONE ctermfg=4
hi Statement cterm=NONE
hi Constant cterm=NONE ctermfg=1
hi Type cterm=NONE
hi PreProc cterm=NONE ctermfg=5
hi Special cterm=NONE ctermfg=5
set paste
"map <C-n> :NERDTree<CR>

" map <c-f> :call JsBeautify()<cr>
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>


" autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>
" autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
" autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
" autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
" autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
let g:formatdef_harttle = '"astyle --style=linux -s4 -U "'
let g:formatters_cpp = ['harttle']
let g:formatters_c = ['harttle']
let g:formatters_java = ['harttle']
noremap <c-f> :Autoformat<CR>
