""" Plug installation

call plug#begin('~/.vim/plugged')
filetype plugin indent on

" Syntax
Plug 'tmhedberg/SimpylFold'
Plug 'scrooloose/syntastic'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'kh3phr3n/python-syntax'
Plug 'tell-k/vim-autopep8'
Plug 'aanari/vim-tsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/vim-js-pretty-template'
Plug 'mxw/vim-jsx'
Plug 'posva/vim-vue'
" Functionality
Plug 'scrooloose/nerdtree'
Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
Plug 'scrooloose/nerdcommenter'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround' 
" Search
Plug 'kien/ctrlp.vim'
Plug 'artur-shaik/vim-javacomplete2'
" Theming
call plug#end()

""" Auto Installation
  if empty(glob("~/.vim/autoload/plug.vim"))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    auto VimEnter * PlugInstall
  endif

  if !empty(glob("~/.fzf/bin/fzf"))
    if empty(glob("~/.fzf/bin/rg"))
      silent !curl -fLo /tmp/rg.tar.gz
            \ https://github.com/BurntSushi/ripgrep/releases/download/0.4.0/ripgrep-0.4.0-x86_64-unknown-linux-musl.tar.gz
      silent !tar xzvf /tmp/rg.tar.gz --directory /tmp
      silent !cp /tmp/ripgrep-0.4.0-x86_64-unknown-linux-musl/rg ~/.fzf/bin/rg
    endif
  endif
  
  if !isdirectory($HOME . "/.vim/undodir")
    call mkdir($HOME . "/.vim/undodir", "p")
  endif

""" Appearance
" **** THEMING BELOW ****
" set background=light
" colorscheme "material.vim"
" **** THEMING ABOVE ****

set complete=.,b,u,]
set wildmode=longest,list:longest
set completeopt=menu,preview
set omnifunc=syntaxcomplete#Complete
set autoread
au FocusGained,BufEnter * checktime
if has('persistent_undo')      "check if your vim version supports it
  set undofile                 "turn on the feature  
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
  endif     

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
set tabstop=2
set shiftwidth=2
set expandtab

:nnoremap gr :grep '\b<cword>\b' *<CR>
:nnoremap GR :grep '\b<cword>\b' %:p:h/*<CR>
" automatically resize windows 
autocmd VimResized * wincmd =

let mapleader = ","

set showcmd

" autocmd FileType python setlocal colorcolumn=79
" autocmd FileType java setlocal colorcolumn=99

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

" typescript stuff
let g:typescript_indent_disable = 1
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

" CTRLP
" Always CTRLP to root dir
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_working_path_mode = 'ra'
" Ignore some folders and files for CtrlP indexing
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip
" let g:ctrlp_user_command = 'find %s -type f'

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


" Typescript and jsx
let g:vim_jsx_pretty_enable_jsx_highlight = 1
let g:vim_jsx_pretty_colorful_config = 1


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_error_symbol = "👉"
let g:syntastic_warning_symbol = "🔥"
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_w = 0
let g:syntastic_quiet_messages={'level':'warning'}
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["html"] }
" filenames like *.xml, *.html, *.xhtml, ...
" Then after you press <kbd>&gt;</kbd> in these files, this plugin will try to close the current tag.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ejs,*.ts,*.tsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non closing tags self closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ejs,*.ts,*.tsx'

" integer value [0|1]
" This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'
" **** ALL SET MODIFIERS ABOVE ****


" **** CUSTOM FUNCTIONS ****
function Find(x)
    echom "Searching for"
    echom x
    grep -H -r x * | less
endfunction

" **** PYTHON STUFF BELOW ****
set encoding=utf-8

au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

" ignore .pyc files in nerdtree
let NERDTreeIgnore=['\.pyc$', '\~$'] 
let NERDTreeShowHidden=1

let python_highlight_all=1

autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>
" autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab
" **** PYTHON STUFF ABOVE ****

" *** JAVA ***
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
map <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)


