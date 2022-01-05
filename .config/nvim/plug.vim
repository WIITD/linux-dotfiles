
call plug#begin()

	Plug 'mg979/vim-visual-multi'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'jiangmiao/auto-pairs'
	Plug 'tpope/vim-surround'
	Plug 'tyru/open-browser.vim'
	Plug 'lifepillar/vim-mucomplete'
	Plug 'vim-scripts/Freebasic-vim-syntax-file'
	Plug 'vim-syntastic/syntastic'

	Plug 'vimsence/vimsence'

	" neovim only plugins "
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'christianchiarulli/nvcode-color-schemes.vim'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'

	Plug 'kyazdani42/nvim-web-devicons'

	Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
	Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
	Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

call plug#end()
