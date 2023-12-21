{
  pkgs,
  lib,
  helpers,
  config,
  theme,
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
  templateSourceVimScript = name: template: data: let
    fileName = "${name}.vim";
  in ''
    source ${helpers.templateFile fileName template data}/${fileName}
  '';
  templateSourceLua = name: template: data: let
    fileName = "${name}.lua";
  in ''
    lua << EOF
    local current_path = package.path
    package.path = current_path .. ";${helpers.templateFile fileName template data}/?.lua"
    require("${name}")
    package.path = current_path
    EOF
  '';
  leader = ",";
in {
  imports = [./coc];

  _module.args = {
    neovim = {
      inherit leader;
      inherit plugin;
      inherit templateSourceVimScript;
    };
  };

  home.shellAliases =
    {
      suvim = "sudo nvim -u ${config.xdg.configHome}/nvim/init.lua";
    }
    // (
      if config.programs.kitty.enable
      then {
        nvim = "${pkgs.writeShellScript "nvim-kitty-spacing" ''
          kitty @ set-spacing padding=0 && nvim $@ && kitty @ set-spacing padding=8
        ''}";
      }
      else {}
    );

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
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
      {
        plugin = nvim-surround;
        config = templateSourceLua "nvim-surround-config" ./nvim-surround.lua {};
      }
      tcomment_vim
      colorizer
      vim-fugitive
      gv-vim
      vim-polyglot
      markdown-preview-nvim
      {
        plugin = lualine-nvim;
        config = templateSourceLua "lualine-nvim-config" ./lualine-nvim.lua {};
      }
      nvim-web-devicons
      theme.neovim
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
          rev = "2c31989063b145830d5f0bea8ab529d2aef2427b";
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
      {
        plugin = plugin {
          repo = "V-Mann-Nick/zen-mode.nvim";
          ref = "show-tabline";
          rev = "7517af227efbeb424f59afba77b82a9dafaf11f9";
        };
        config = templateSourceLua "zen-mode-nvim-config" ./zen-mode-nvim.lua {};
      }
      plenary-nvim
      {
        plugin = nvim-cokeline;
        config = templateSourceLua "nvim-cokeline-config" ./nvim-cokeline.lua {};
      }
      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        config = templateSourceLua "telescope-nvim-config" ./telescope-nvim.lua {};
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
      #     vim.g.loaded_netrw = 1
      #     vim.g.loaded_netrwPlugin = 1
      #
      #     require("nvim-tree").setup()
      #     vim.keymap.set("n", "<Space>e", ":NvimTreeClose<Enter>:G<Enter>", { silent = true })
      #     EOF
      #   '';
      # }
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
      # {
      #   plugin = fzf-vim;
      #   config = templateSourceVimScript "fzf-vim-config" ./fzf-vim.vim {};
      # }
    ];
  };
}
