let mapleader = "{{leader}}"

set termguicolors
set number relativenumber
set pumheight=10
set mouse=a
set clipboard+=unnamedplus
set signcolumn=yes:1
set nohlsearch

noremap <C-z> <C-u>
" Search for visually selected text
vnoremap // y/<C-R>"<CR>
" Insert line without going into insert
nmap mo o<Esc>k
nmap mO O<Esc>j
" Replace all is aliased to S.
nnoremap <leader>S :%s//g<Left><Left>
" Shortcutting split navigation, saving a keypress:
nnoremap <Space>h <C-w>h
nnoremap <Space>j <C-w>j
nnoremap <Space>k <C-w>k
nnoremap <Space>l <C-w>l
" easy windows resizing
" nnoremap <M-j> :resize -10<cr>
" Use alt + hjkl to resize windows
nnoremap <silent> <C-M-j>    :resize -2<CR>
nnoremap <silent> <C-M-k>    :resize +2<CR>
nnoremap <silent> <C-M-h>    :vertical resize -2<CR>
nnoremap <silent> <C-M-l>    :vertical resize +2<CR>

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
autocmd filetype py set tabstop=4 softtabstop=4 shiftwidth=4
autocmd filetype lua set tabstop=4 softtabstop=4 shiftwidth=4
