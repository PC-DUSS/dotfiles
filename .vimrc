" Start by installing Vundle at: https://github.com/VundleVim/Vundle.vim


"source $VIMRUNTIME/defaults.vim

" Vundle config start
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo

" For YouCompleteMe, install the plugin using Vundle, then follow the
" instructions on the github to compile it inside it's installed directory
Plugin 'ycm-core/YouCompleteMe'

Plugin 'tpope/vim-fugitive'
Plugin 'sheerun/vim-polyglot'
Plugin 'rafi/awesome-vim-colorschemes'
Plugin 'jnurmine/Zenburn'
Plugin 'dracula/vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-eunuch'
Plugin 'vim-utils/vim-man'
Plugin 'lyuts/vim-rtags'
Plugin 'preservim/tagbar'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mbbill/undotree'
Plugin 'junegunn/fzf.vim'
Plugin 'itchyny/lightline.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'preservim/nerdcommenter'
Plugin 'mattn/emmet-vim'
Plugin 'gregsexton/MatchTag'
Plugin 'dense-analysis/ale'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

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


" Rest of config
set hidden
syntax on
set backspace=indent,eol,start
set wildmenu
set laststatus=2
set noerrorbells
set number
set nowrap
" Store swapfiles in ~/.vim/tmp/ folder.
set directory^=$HOME/.vim/tmp//
set nobackup
" You must create that directory manually for it to work.
set undodir=~/.vim/undodir
set undofile
set incsearch
set smartcase
set expandtab

" Autoremove trailing spaces
autocmd BufWritePre *.py :%s/\s\+$//e

" Sane text files
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8

" 80char column limit settings.
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Theme settings
colorscheme zenburn
set background=dark
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

" Make <Spacebar> the leader key for mappings.
let mapleader=" "

" Emmet shortcuts
let g:user_emmet_mode='n' " Only enable emmet functions in normal mode.
let g:user_emmet_leader_key=','

let g:netrw_browse_split=2
let g:netrw_winsize=25
let g:ctrlp_use_caching=0

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Code folding
map <buffer> <S-Tab> :setlocal fdm=syntax<CR>
autocmd Filetype python map <buffer> <S-Tab> :setlocal fdm=indent <CR>

" Python files.
autocmd FileType python map <buffer> <F5> :w<CR>:exec '!clear && python3' shellescape(@%, 1)<CR>

" Javascript files.
autocmd FileType javascript map <buffer> <F5> :w<CR>:exec '!clear && node' shellescape(@%, 1)<CR>

" C and C++ files.
autocmd filetype c nnoremap <F5> :w <bar> exec '!clear && gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!clear && g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>

" Java files.
autocmd FileType java map <buffer> <F5> :w<CR>:exec '!clear && javac '.shellescape(@%, 1).' && java '.shellescape('%:r')<CR>
autocmd FileType java setlocal colorcolumn=120 shiftwidth=4 tabstop=4 softtabstop=4 expandtab

" HTML files.
autocmd FileType html map <buffer> <F5> :w<CR>:exec '!clear && firefox '.shellescape(@%, 1)<CR>

" F8 hotkey for the Tagbar
nmap <F8> :TagbarToggle<CR>

" F7 hotkey for the NERDTree
nmap <F7> :NERDTreeToggle<CR>

" Custom ALE linter(s)
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   }

" Show trailing whitespace
autocmd BufWinEnter <buffer> match Error /\s\+$/
autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
autocmd InsertLeave <buffer> match Error /\s\+$/
autocmd BufWinLeave <buffer> call clearmatches()


" Set cursorline in bold
"set cursorline

"hi clear CursorLine
"augroup CLClear
    "autocmd! Colorscheme * hi clear CursorLine
"augroup END

"hi CursorLineNR cterm=bold
"augroup CLNRset
    "autocmd! Colorscheme * hi CursorLineNR cterm=bold
"augroup END

" End of config
