{ pkgs, lib, ... }:
let
  plugin = { repo, ref, rev }: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = rev;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      inherit ref rev;
    };
  };
in
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;
  coc = {
    enable = true;
    settings = {
      "workspace.bottomUpFiletypes" = ["*"];
      "workspace.workspaceFolderCheckCwd" = false;
      "tsserver.useLocalTsdk" = true;
      "typescript.format.enable" = false;
      "javascript.format.enable" = false;
      "python.formatting.provider" = "black";
      "python.linting.flake8Enabled" = true;
      "pyright.organizeimports.provider" = "isort";
      "suggest.noselect" = true;
      "eslint.autoFixOnSave" = false;
      "eslint.workingDirectories" = [{ "mode" = "auto"; }];
      "eslint.packageManager" = "pnpm";
      "yaml.customTags" = [ "!reference sequence" ];
      "rust-analyzer.server.path" = "rust-analyzer";
    };
    pluginConfig = ''
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
    '';
  };
  plugins = with pkgs.vimPlugins; [
    vim-nix
    nord-vim
    {
      plugin = auto-pairs;
      config = ''
        let g:AutoPairsMultilineClose = 0
        autocmd FileType json let b:autopairs_enabled = 0
      '';
    }
    {
      plugin = vim-smoothie;
      config = ''
        nnoremap <unique> <Space>d <cmd>call smoothie#do("\<C-D>") <CR>
        vnoremap <unique> <Space>d <cmd>call smoothie#do("\<C-D>") <CR>
        nnoremap <unique> <Space>u <cmd>call smoothie#do("\<C-U>") <CR>
        vnoremap <unique> <Space>u <cmd>call smoothie#do("\<C-U>") <CR>
      '';
    }
    vim-surround
    tcomment_vim
    colorizer
    vim-fugitive
    gv-vim
    {
      plugin = fzf-vim;
      config = ''
        " This is the default extra key bindings
        let g:fzf_action = {
          \ 'ctrl-t': 'tab split',
          \ 'ctrl-x': 'split',
          \ 'ctrl-v': 'vsplit' }

        " Enable per-command history.
        " CTRL-N and CTRL-P will be automatically bound to next-history and
        " previous-history instead of down and up. If you don't like the change,
        " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
        " let g:fzf_history_dir = '~/.local/share/fzf-history'

        nmap <silent> <space>p :Files<CR>
        nmap <silent> <space>b :Buffers<CR>
        nmap <silent> <space>/ :BLines<CR>
        nmap <silent> <space>g :Rg<CR>


        let g:fzf_tags_command = 'ctags -R'
        " Border color
        let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.7, 'height': 0.7,'yoffset':0.5,'xoffset': 0.5, 'border': 'rounded' } }

        let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
        let $FZF_DEFAULT_COMMAND="rg --files --hidden"

        "Get Files
        command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


        " Get text in files with Rg
        command! -bang -nargs=* Rg
          \ call fzf#vim#grep(
          \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
          \   fzf#vim#with_preview(), <bang>0)

        " Ripgrep advanced
        function! RipgrepFzf(query, fullscreen)
          let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
          let initial_command = printf(command_fmt, shellescape(a:query))
          let reload_command = printf(command_fmt, '{q}')
          let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
          call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
        endfunction

        command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

        " Git grep
        command! -bang -nargs=* GGrep
          \ call fzf#vim#grep(
          \   'git grep --line-number '.shellescape(<q-args>), 0,
          \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)
      '';
    }
    vim-polyglot
    {
      plugin = vimspector;
      config = ''
        let g:vimspector_enable_mappings = 'HUMAN'

        nmap <leader>vl :call vimspector#Launch()<CR>
        nmap <leader>vr :VimspectorReset<CR>
        nmap <leader>ve :VimspectorEval
        nmap <leader>vw :VimspectorWatch
        nmap <leader>vo :VimspectorShowOutput
        nmap <leader>vi <Plug>VimspectorBalloonEval
        xmap <leader>vi <Plug>VimspectorBalloonEvallet g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2']
      '';
    }
    markdown-preview-nvim
    {
      plugin = (plugin { 
        repo = "nvim-lualine/lualine.nvim";
        ref = "master";
        rev = "2248ef254d0a1488a72041cfb45ca9caada6d994";
      });
      config = ''
        lua << EOF
        require("lualine").setup({
          options = {
            theme = "nordfox"
          }
        })
        EOF
      '';
    }
    nvim-web-devicons
    {
      plugin = barbar-nvim;
      config = ''
        lua << EOF
        require("bufferline").setup({
          animation = false,
          auto_hide = true
        })
        EOF
        nnoremap <silent> <Space>, <Cmd>BufferPrevious<CR>
        nnoremap <silent> <Space>. <Cmd>BufferNext<CR>
        nnoremap <silent> <Space>< <Cmd>BufferMovePrevious<CR>
        nnoremap <silent> <Space>> <Cmd>BufferMoveNext<CR>
        nnoremap <silent> <Space>w <Cmd>bdelete<CR>
      '';
    }
    nvim-treesitter
    {
      plugin = nightfox-nvim;
      config = ''
        lua << EOF
        require("nightfox").setup({
          options = {
            styles = {
              types = "NONE",
              numbers = "NONE",
              strings = "NONE",
              comments = "italic",
              keywords = "bold,italic",
              constants = "NONE",
              functions = "italic",
              operators = "NONE",
              variables = "NONE",
              conditionals = "italic",
              virtual_text = "NONE",
            }
          }
        })
        vim.cmd("colorscheme nordfox")
        EOF
      '';
    }
    vim-gitgutter
    lightspeed-nvim
    {
      plugin = (plugin {
        repo = "github/copilot.vim";
        ref = "release";
        rev = "309b3c803d1862d5e84c7c9c5749ae04010123b8";
      });
      config = ''
        imap <silent><script><expr> <C-Enter> copilot#Accept("\<CR>")
        let g:copilot_no_tab_map = v:true
      '';
    }
    {
      plugin = lf-vim;
      config = ''
        let g:lf_map_keys = 0
        map <space>r :Lf<CR>
        let g:lf_replace_netrw = 1
      '';
    }
    (plugin {
      repo = "wuelnerdotexe/vim-astro";
      ref = "main";
      rev = "9b4674ecfe1dd84b5fb9b4de1653975de6e8e2e1";
    })
  ];
  extraConfig = ''
    let mapleader = ","
    set termguicolors
    set number relativenumber
    set tabstop=8 softtabstop=2 shiftwidth=2 expandtab smarttab
    set pumheight=10
    set mouse=a
    set clipboard+=unnamedplus
    set signcolumn=yes:1
    set nohlsearch
    set foldmethod=syntax
    let javaScript_fold=1
    set foldlevelstart=99

    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <silent><expr> <c-space> coc#refresh()
    " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
    "   \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction
    nnoremap <silent> K :call ShowDocumentation()<CR>
    autocmd CursorHold * silent call CocActionAsync('highlight')
    nmap <leader>rn <Plug>(coc-rename)
    nmap <leader>rf <Plug>(coc-refactor)
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  :Format<Enter>
    nmap <silent> <leader>F  :CocCommand<Space>eslint.executeAutofix<Enter>
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>ac  <Plug>(coc-codeaction)
    nmap <leader>qf  <Plug>(coc-fix-current)
    nmap <leader>cl  <Plug>(coc-codelens-action)
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
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

    autocmd filetype py set tabstop=4 softtabstop=2 expandtab shiftwidth=2 smarttab
  '';
}
