let mapleader = "{{leader}}"

let g:coc_global_extensions = ["coc-tsserver","coc-prettier","coc-eslint","coc-pyright","coc-yaml","coc-json","coc-ltex","coc-rust-analyzer"]
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=900
set shortmess+=c
hi CocUnderline gui=undercurl term=undercurl
hi CocErrorHighlight gui=undercurl guisp=red
hi CocWarningHighlight gui=undercurl guisp=yellow
set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ CheckBackspace() ? "\<TAB>" :
  \ coc#refresh()

" Shitf + Tab to jump back threw recommendations
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion (if not already shown)
inoremap <silent><expr> <c-space> coc#refresh()

" Enter to confirm completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
nnoremap <silent> K :call ShowDocumentation()<CR>

" Symbol referecnes highlighted after hold of cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Renaming & Refactoring
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)

" Formatting
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  :Format<Enter>

nmap <silent> <leader>F  :CocCommand<Space>eslint.executeAutofix<Enter>

" TODO Does something, not sure
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Open code actions of selected region. Press 'j' or 'k' to navigate.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)

" Open quick fick for current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Trigger code lens actions in current buffer. Not sure what it means
nmap <leader>cl  <Plug>(coc-codelens-action)

" Motions around language constructs
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Scrolling of preview window
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
nnoremap <silent> <leader>cr :CocRestart<Enter>
nnoremap <silent> <leader>cf :CocCommand workspace.renameCurrentFile<Enter>
