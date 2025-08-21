""" Plug installation
call plug#begin('~/.vim/plugged')
filetype plugin indent on

" Syntax
Plug 'tmhedberg/SimpylFold'
Plug 'scrooloose/syntastic'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'kh3phr3n/python-syntax'
Plug 'tell-k/vim-autopep8'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'evanleck/vim-svelte'
" Plug 'isRuslan/vim-es6'
Plug 'dense-analysis/ale'
"
" Functionality
Plug 'scrooloose/nerdtree'
" Plug 'powerline/powerline'
Plug 'scrooloose/nerdcommenter'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround' 
" Search
Plug 'kien/ctrlp.vim'
" Plug 'artur-shaik/vim-javacomplete2'
" Theming
Plug 'vim-airline/vim-airline'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
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

" https://jeffkreeftmeijer.com/vim-number/
" turn hybrid line numbers on
:set number relativenumber
:set nu rnu
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

""" Appearance
" **** THEMING BELOW ****
" set background=light
colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha


" Enable completion where available.
" This setting must be set before ALE is loaded.
" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 1
" let g:ale_sign_error = '⁉️'
" let g:ale_sign_warning = '⚠️'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
" **** THEMING ABOVE ****

" **** ALL SET MODIFIERS BELOW ****
set tabstop=2
set shiftwidth=2
set expandtab
set nocompatible
set hidden
set complete=.,b,u,]
set wildmode=longest,list:longest
set completeopt=menu,preview
set omnifunc=syntaxcomplete#Complete
set autoread

" persistent undo
set undofile                 "turn on the feature  
set undodir=$HOME/.vim/undo  "directory where the undo files will be stored

set showcmd
set splitbelow
set splitright

" Highlight all matches at search
set hlsearch

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

syntax on
au FocusGained,BufEnter * checktime


" **** ALL MAPPINGS BELOW ****
" Mark replacement
noremap t `

" Select all with Ctrl-A
" noremap <C-a> <esc>gg0vG$<CR>

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

:nnoremap gr :grep '\b<cword>\b' *<CR>
:nnoremap GR :grep '\b<cword>\b' %:p:h/*<CR>
" automatically resize windows 
autocmd VimResized * wincmd =

let mapleader = ","

autocmd FileType python setlocal colorcolumn=79
autocmd FileType java setlocal colorcolumn=99

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
let g:typescript_indent_disable = 1
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''

let g:vim_jsx_pretty_enable_jsx_highlight = 1
let g:vim_jsx_pretty_colorful_config = 1

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_python_checkers = ['python3', 'JavaScript', 'TypeScript']
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
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ejs,*.ts,*.tsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non closing tags self closing in the specified files.
let g:closetag_xhtml_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ejs,*.ts,*.tsx'

" integer value [0|1]
" This will make the list of non closing tags case sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

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
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" **** PYTHON STUFF ABOVE ****
" JS
" autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 expandtab
" SVELTE
let g:svelte_indent_script = 0
let g:svelte_indent_style = 0
