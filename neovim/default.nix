args @ {
  pkgs,
  lib,
  ...
}: let
  plugin = {
    repo,
    ref,
    rev,
  }:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        inherit ref rev;
      };
    };
  templateFile = name: template: data:
    with pkgs;
      stdenv.mkDerivation {
        name = "${name}";
        nativeBuildInpts = [mustache-go];
        passAsFile = ["jsonData"];
        jsonData = builtins.toJSON data;
        phases = ["buildPhase" "installPhase"];
        buildPhase = ''
          ${mustache-go}/bin/mustache $jsonDataPath ${template} > rendered_file
        '';
        installPhase = ''
          mkdir -p $out
          cp rendered_file $out/${name}
        '';
      };
  templateSourceVimScript = name: template: data: let
    fileName = "${name}.vim";
  in ''
    source ${templateFile fileName template data}/${fileName}
  '';
  templateSourceLua = name: template: data: let
    fileName = "${name}.lua";
  in ''
    lua << EOF
    local current_path = package.path
    package.path = current_path .. ";${templateFile fileName template data}/?.lua"
    require("${name}")
    EOF
  '';
  leader = ",";
  context = {inherit plugin templateFile templateSourceVimScript templateSourceLua leader;} // args;
in {
  enable = true;
  viAlias = true;
  vimAlias = true;
  withNodeJs = true;
  coc = import ./coc context;
  extraConfig = templateSourceVimScript "nvim-extra-config" ./base-config.vim {inherit leader;};
  plugins = with pkgs.vimPlugins; [
    {
      plugin = auto-pairs;
      config = templateSourceVimScript "auto-pairs-config" ./auto-pairs.vim {};
    }
    {
      plugin = vim-smoothie;
      config = templateSourceVimScript "vim-smoothie-config" ./vim-smoothie.vim {};
    }
    vim-surround
    tcomment_vim
    colorizer
    vim-fugitive
    gv-vim
    {
      plugin = fzf-vim;
      config = templateSourceVimScript "fzf-vim-config" ./fzf-vim.vim {};
    }
    vim-polyglot
    markdown-preview-nvim
    {
      plugin = lualine-nvim;
      config = templateSourceLua "lualine-nvim-config" ./lualine-nvim.lua {};
    }
    nvim-web-devicons
    {
      plugin = nightfox-nvim;
      config = templateSourceLua "nightfox-nvim-config" ./nightfox-nvim.lua {};
    }
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = templateSourceLua "nvim-treesitter-config" ./nvim-treesitter.lua {};
    }
    vim-gitgutter
    lightspeed-nvim
    {
      plugin = plugin {
        repo = "github/copilot.vim";
        ref = "release";
        rev = "309b3c803d1862d5e84c7c9c5749ae04010123b8";
      };
      config = templateSourceVimScript "copilot-vim-config" ./copilot-vim.vim {};
    }
    {
      plugin = toggleterm-nvim;
      config = templateSourceLua "toggleterm-nvim-config" ./toggleterm-nvim.lua {};
    }
    {
      plugin = plugin {
        repo = "lmburns/lf.nvim";
        ref = "master";
        rev = "69ab1efcffee6928bf68ac9bd0c016464d9b2c8b";
      };
      config = templateSourceLua "lf-nvim-config" ./lf-nvim.lua {};
    }
    (plugin {
      repo = "wuelnerdotexe/vim-astro";
      ref = "main";
      rev = "9b4674ecfe1dd84b5fb9b4de1653975de6e8e2e1";
    })
    {
      plugin = no-neck-pain-nvim;
      config = templateSourceLua "no-neck-pain-nvim-config" ./no-neck-pain-nvim.lua {};
    }
    plenary-nvim
    {
      plugin = plugin {
        repo = "willothy/nvim-cokeline";
        ref = "main";
        rev = "2e71292a37535fdbcf0f9500aeb141021d90af8b";
      };
      config = templateSourceLua "nvim-cokeline-config" ./nvim-cokeline.lua {};
    }
    # {
    #   plugin = barbar-nvim;
    #   config = ''
    #     lua << EOF
    #     require("bufferline").setup({
    #       animation = false,
    #       auto_hide = true
    #     })
    #     EOF
    #     nnoremap <silent> <Space>, <Cmd>BufferPrevious<CR>
    #     nnoremap <silent> <Space>. <Cmd>BufferNext<CR>
    #     nnoremap <silent> <Space>< <Cmd>BufferMovePrevious<CR>
    #     nnoremap <silent> <Space>> <Cmd>BufferMoveNext<CR>
    #     nnoremap <silent> <Space>w <Cmd>bdelete<CR>
    #   '';
    # }
    # {
    #   plugin = nord-nvim;
    #   config = ''
    #     colorscheme nord
    #   '';
    # }
    # {
    #   plugin = onenord-nvim;
    #   config = ''
    #     colorscheme onenord
    #   '';
    # }
    # {
    #   plugin = plugin {
    #     repo = "AlexvZyl/nordic.nvim";
    #     ref = "main";
    #     rev = "be1bab59c56668af7020af11190ec7fcd25d59b4";
    #   };
    #   config = ''
    #     colorscheme nordic
    #   '';
    # }
    # {
    #   plugin = lf-vim;
    #   config = ''
    #     let g:lf_map_keys = 0
    #     map <space>r :Lf<CR>
    #     let g:lf_replace_netrw = 1
    #   '';
    # }
    # {
    #   plugin = nvim-tree-lua;
    #   config = ''
    #     lua << EOF
    #     require("nvim-tree").setup({
    #       diagnostics = {
    #         enable = true,
    #         icons = {
    #           hint = "",
    #           info = "",
    #           warning = "",
    #           error = "",
    #         }
    #       },
    #       git = {
    #         enable = false
    #       }
    #     })
    #     EOF
    #   '';
    # }
    # Required for cokeline
    # {
    #   plugin = vimspector;
    #   config = ''
    #     let g:vimspector_enable_mappings = 'HUMAN'
    #
    #     nmap <leader>vl :call vimspector#Launch()<CR>
    #     nmap <leader>vr :VimspectorReset<CR>
    #     nmap <leader>ve :VimspectorEval
    #     nmap <leader>vw :VimspectorWatch
    #     nmap <leader>vo :VimspectorShowOutput
    #     nmap <leader>vi <Plug>VimspectorBalloonEval
    #     xmap <leader>vi <Plug>VimspectorBalloonEvallet g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2']
    #   '';
    # }
  ];
}
