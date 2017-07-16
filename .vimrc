set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" add plugins below
Plugin 'tmhedberg/SimpylFold'
Plugin 'scrooloose/syntastic'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'kh3phr3n/python-syntax'
"Plugin 'kien/ctrlp.vim'
"Plugin 'nvie/vim-flake8'

call vundle#end()
filetype plugin indent on


" **** ALL MAPPINGS BELOW ****

" Select all with Ctrl-A
noremap <C-a> <esc>gg0vG$<CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Enable folding with spacebar
" nnoremap <space> za
inoremap <C-e> <C-n>

nnoremap <C-n> :NERDTreeToggle<CR>
" **** ALL MAPPINGS ABOVE ****





" **** ALL SET MODIFIERS BELOW ****
" automatically resize windows 
autocmd VimResized * wincmd =

set showcmd

set splitbelow
set splitright

" Highlight all matches at search
set hlsearch
syntax on

" Statusline formatting
" set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\
"  \ [%l/%L\ (%p%%)

" always show status line
set laststatus=2

" Enable code folding
set foldmethod=indent
set foldlevel=99

" normal backspace
set backspace=indent,eol,start

" Line numbers
set nu
set relativenumber
" Copy from VIM and outside
set clipboard=unnamed

let g:Powerline_symbols = 'fancy'
" **** ALL SET MODIFIERS ABOVE ****




" **** THEMING BELOW ****

"if has('gui_running')
" set background=dark
" colorscheme solarized
"else
" colorscheme zenburn
"endif
" Press F5 to change between solarized dark/light
" call togglebg#map("<F5>")
" **** THEMING ABOVE ****



" **** PYTHON STUFF BELOW ****
set encoding=utf-8

au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

" ignore .pyc files in nerdtree
let NERDTreeIgnore=['\.pyc$', '\~$'] 

" Run flake8 upon saving .py files
" autocmd BufWritePost *.py call Flake8()

let python_highlight_all=1
" **** PYTHON STUFF ABOVE ****
