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
Plugin 'tell-k/vim-autopep8'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
"Plugin 'nvie/vim-flake8'

call vundle#end()
filetype plugin indent on
filetype plugin on


" **** ALL MAPPINGS BELOW ****
" Mark replacement
noremap t `

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
:nnoremap gr :grep '\b<cword>\b' *<CR>
:nnoremap GR :grep '\b<cword>\b' %:p:h/*<CR>
" automatically resize windows 
autocmd VimResized * wincmd =

let mapleader = ","

set showcmd

autocmd FileType python setlocal colorcolumn=79
autocmd FileType java setlocal colorcolumn=99

set splitbelow
set splitright

" Highlight all matches at search
set hlsearch
syntax on

" always show status line, also used for powerline
set laststatus=2

" Enable code folding
set foldmethod=indent
set foldlevel=99

" normal backspace
set backspace=indent,eol,start

" Line numbers
set nu
" set relativenumber
" Copy from VIM and outside
set clipboard=unnamed

let g:Powerline_symbols = 'fancy'

" Always CTRLP to root dir
" let g:ctrlp_root_markers = ['.ctrlp']

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" **** ALL SET MODIFIERS ABOVE ****




" **** THEMING BELOW ****
"colorscheme vim-material
"let g:airline_theme='material'

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

let python_highlight_all=1

autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
" **** PYTHON STUFF ABOVE ****
