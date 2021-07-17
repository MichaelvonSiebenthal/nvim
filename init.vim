" curl fLO $Home/.config/nvim/autoload/plug.vim --create dir \
" 	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.config/nvim/plugged')
   Plug 'gruvbox-community/gruvbox'		            " gruvbox colorscheme
   " Plug 'arcticicestudio/nord-vim'                  " nord colorscheme
   Plug 'junegunn/seoul256.vim'                     " Seoul256 colorscheme
   Plug 'tpope/vim-fugitive'	                      " git integration, use command :Git
   Plug 'airblade/vim-gitgutter'                   " git gutter
   Plug 'preservim/nerdtree'	                      " open file directory with ctrl n
   Plug 'jremmen/vim-ripgrep'                       " ripgrep
   Plug 'vim-utils/vim-man'                         " man commands 
   Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}
   Plug 'ctrlpvim/ctrlp.vim'	                      " Do Fuzzy searche directory using ctrl p
   Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " fzf search
   Plug 'junegunn/fzf.vim'
   Plug 'neoclide/coc.nvim', {'branch': 'release'}  " autocompletion general
   Plug 'itchyny/lightline.vim'                     " minimal status bar
   Plug 'tmsvg/pear-tree'                           " autocomplete bracket, baces etc.
   Plug 'preservim/tagbar'                          " Tags management
   Plug 'JuliaEditorSupport/julia-vim'              " Julia Symbols and other utils
   Plug 'mbbill/undotree'                           " undo tree of deleted sessions
   Plug 'karoliskoncevicius/vim-sendtowindow'       " send code to window
   Plug 'sheerun/vim-polyglot'                      " Syntax Highlighting for most languages
   "Plug 'vim-airline/vim-airline'                   " status/tabline
   "Plug 'vim-airline/vim-airline-themes'            " status tabline themes
   Plug 'ap/vim-css-color'                          " CSS colors
   Plug 'lervag/vimtex'                             " Latex Plug in 
call plug#end()

" Basic Requirements
set nocompatible                " be iMproved required
filetype indent plugin on	      " required
syntax on                       " show syntax
set noerrorbells                " no error noice
set updatetime=150              " set update time for gitgutter update

" set colorscheme
let g:gruvbox_contrast_dark='soft'
" let g:seoul256_background = 236
colorscheme gruvbox
set background=dark
set colorcolumn=80
set signcolumn=yes              " adds space next to numbers
highlight Colorcolumn ctermbg=0 guibg=lightgrey

autocmd BufEnter * colorscheme gruvbox
autocmd BufEnter * highlight Colorcolumn ctermbg=0 guibg=lightgrey
autocmd BufEnter *.tex colorscheme seoul256
autocmd BufEnter *.tex set textwidth=79
let g:seoul256_background = 236
autocmd BufEnter FileType markdown colorscheme seoul256
let g:seoul256_background = 236

" set colorcolumn to 150 for tex files
autocmd BufEnter *.tex set colorcolumn=80

" mac specific for deleting properly
set backspace=indent,eol,start

" Allow for normal copy/paste
set clipboard=unnamedplus

" set local working directory always to the file being edited
autocmd BufEnter * silent! lcd %:p:h
" set autochdir " sets general working directory to file. not just local

" git setting 
if executable('rg')
    let g:rg_derive_root='true'
endif

" leader key
let mapleader = " "
let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25
" ag is fast enough that ctrlP doesn't need to cache.
let g:ctrlp_use_caching=0

" mouse
set mouse=a
let g:is_mouse_enabled = 1
noremap <silent> <Leader>m :call ToggleMouse()<CR>
function ToggleMouse()
    if g:is_mouse_enabled == 1
        echo "Mouse OFF"
        set mouse=
        let g:is_mouse_enabled = 0
    else
        echo "Mouse ON"
        set mouse=a
        let g:is_mouse_enabled = 1
    endif
endfunction

" line numbers
set relativenumber
set nu
set wrap

" case insensitive searching
set ignorecase
set smartcase 

" tags
map <space>t :TagbarToggle<CR>

" Indentation settings
set smartindent
set shiftwidth=4
set softtabstop=4 tabstop=4
set shiftwidth=4
set expandtab
set smartcase
set nohlsearch
set hidden
set incsearch
set scrolloff=8

" no junk files
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile

" ligthline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" language spelling
setlocal spell
set spelllang=en_us

" Latex Settings
let g:tex_flavor = 'latex'
set sw=2
set iskeyword+=:
let g:vimtex_log_ignore = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
        \ 'Token not allowed in a PDF string',
      \ ]
let g:vimtex_view_method = "skim"
let g:vimtex_view_general_viewer
      \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

" This adds a callback hook that updates Skim after compilation
"let g:vimtex_compiler_callback_hooks = ['UpdateSkim']
function! UpdateSkim(status)
  if !a:status | return | endif

  let l:out = b:vimtex.out()
  let l:tex = expand('%:p')
  let l:cmd = [g:vimtex_view_general_viewer, '-r']
  if !empty(system('pgrep Skim'))
  call extend(l:cmd, ['-g'])
  endif
  if has('nvim')
  call jobstart(l:cmd + [line('.'), l:out, l:tex])
  elseif has('job')
  call job_start(l:cmd + [line('.'), l:out, l:tex])
  else
  call system(join(l:cmd + [line('.'), shellescape(l:out), shellescape(l:tex)], ' '))
  endif
endfunction

let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_mode = 2

" markdown --sudo npm -g install instant-markdown-d@next--
let g:instant_markdown_autostart = 0
let g:livepreview_previewer = 'open -a Skim'
" reset send to window shortcuts
let g:sendtowindow_use_defaults=0

" Nerdtree show hidden files
let NERDTreeShowHidden=1

" set status tabline themes
" let g:airline_theme='base16_gruvbox_dark_hard'

" julia ctags
let g:tagbar_type_julia = {
   \ 'ctagstype' : 'julia',
    \ 'kinds'     : [
     \              'a:abstract', 'i:immutable', 't:type', 'f:function', 'm:macro']
    \ }

" sendtowindow keymap
nmap L <Plug>SendRight
xmap L <Plug>SendRightV
nmap H <Plug>SendLeft
xmap H <Plug>SendLeftV
nmap K <Plug>SendUp
xmap K <Plug>SendUpV
nmap J <Plug>SendDown
xmap J <Plug>SendDownV

" escape terminal
:tnoremap <Esc> <C-\><C-n>

" nerdtree keymap
map <silent> <C-space> :NERDTreeToggle<CR>

" mardkown keymap
nnoremap <C-m><CR> :InstantMarkdownPreview<CR>
nnoremap <C-m><BS> :InstantMarkdownStop<CR>

" Window Switching
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>ps :Rg<SPACE>
nnoremap <silent> <leader>+ :vertical resize +5<CR>
nnoremap <silent> <leader>- :vertical resize -5<CR>

" enable file path copy
:nnoremap <Leader>c :let @+=expand('%:p')<CR>

" FZF keybinding
nnoremap <leader>f :Files<CR>
