set number
syntax on
set tabstop=4
set shiftwidth=2
set expandtab
set autoindent
set cursorline
set showcmd
filetype indent on
set wildmenu
set lazyredraw
set showmatch

set noerrorbells
set novisualbell

call plug#begin()
Plug 'sjl/badwolf'
Plug 'tribela/vim-transparent'
Plug 'preservim/NERDTree'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'mg979/vim-visual-multi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tyru/open-browser.vim'
Plug 'lifepillar/vim-mucomplete'
Plug 'vim-scripts/Freebasic-vim-syntax-file'
call plug#end()

let g:NERDTreeWinPos = "right"

colorscheme badwolf
set completeopt+=menuone
set completeopt+=noselect

nnoremap <f2> :Files<CR>
nnoremap <f3> :NERDTreeToggle<CR>
nnoremap <f4> ::GitGutterToggle<CR>
nnoremap <f5> :GFiles?<CR>
nnoremap <space> :noh<CR>
