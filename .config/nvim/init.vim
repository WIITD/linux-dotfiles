
" load nvim config
source ~/.config/nvim/config.vim

" load custom commands
source ~/.config/nvim/commands.vim

autocmd BufNewFile,BufRead .zig set expandtab filetype=zig

" load plugins and their configs
source ~/.config/nvim/plug.vim
source ~/.config/nvim/plugs.vim

colorscheme nord

set completeopt+=menuone
set completeopt+=noselect

" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif

" load keymaps
source ~/.config/nvim/map.vim
