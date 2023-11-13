args@{ config, pkgs, lib, directories, username, homeDirectory, ... }:
let 
  aliases =
    let
      directoryEntryToAliasEntryList = name: { aliases, path }: (
        map (alias: { name = alias; value = path; }) aliases
      );
      aliasEntryLists = lib.mapAttrsToList directoryEntryToAliasEntryList directories;
      aliasEntries = builtins.concatLists aliasEntryLists;
    in builtins.listToAttrs aliasEntries;
  aliasesCdls = 
    let
      cdls = dir: "cd ${dir} && ls";
    in lib.mapAttrs (name: dir: cdls dir) aliases;
  nullPackage = name: pkgs.writeShellScriptBin name "";
  lfcdSource = pkgs.writeText "lfcd-source" ''
    lfcdFn () {
      tmp="$(mktemp)"
      lf -last-dir-path="$tmp" "$@"
      if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
          if [ "$dir" != "$(pwd)" ]; then
            cd "$dir"
          fi
        fi
      fi
    }
  '';
  context = args // { inherit aliases; };
in
{
  home = {
    inherit username homeDirectory;
    stateVersion = "23.11";
    sessionVariables = {
      TERMINAL = "kitty";
      BROWSER = "firefox";
      EDITOR = "nvim";
      VISUAL = "nvim";

      # Podman auth
      REGISTRY_AUTH_FILE = "${config.xdg.configHome}/containers/auth.json";
    };
    sessionPath = [
      "${homeDirectory}/.local/bin"
      "${homeDirectory}/.yarn/bin"
    ];
    packages = with pkgs; [
      lsd
      neofetch
      nodejs_21
      yarn
      podman
      podman-compose
      ripgrep
      fzf
      postgresql
      xclip
      htop
      trash-cli
      flameshot
      jq
      nomad
      shellcheck
      watchman
      cbonsai
      viu
      imagemagick
      consul
      vault
      nomad
      direnv
      vscode
      scc
      glow
      odt2txt
      catdoc
      catdocx
      ffmpegthumbnailer
      python310Packages.ipython
      terraform
      nomad-pack
      go
      nixpkgs-fmt
      cpio
      gitleaks
      bfg-repo-cleaner
      glab
      exif
      qpdf
      speedtest-cli
      jpegoptim
      nodePackages.ts-node
    ];
    shellAliases = {
      ls = "lsd -la";
      suvim = "sudo nvim -u ${config.xdg.configHome}/nvim/init.lua";
      g = "git";
      sw = "home-manager switch";
      home = "$EDITOR ${config.xdg.configHome}/home-manager/home.nix";
      pc = "podman-compose";
      "sensible-editor" = "$EDITOR";
      c = "nvim .";
      py = "poetry";
      ipv = "ipython --TerminalInteractiveShell.editing_mode=vi";
      n = "pnpm";
      l = "source ${lfcdSource} && lfcdFn";
      D = "trash-put";
      kitty = "__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json /usr/bin/kitty";
      envycontrol = "sudo python ${directories.code.path}/open-source/envycontrol/envycontrol.py";
      p = "sudo pacman";
    } // aliasesCdls;
  };
  fonts.fontconfig.enable = true;

  programs.kitty = import ./kitty context;

  programs.git = import ./git context;

  programs.starship = import ./starship context;

  programs.zsh = import ./zsh context;

  programs.neovim = import ./neovim context;

  programs.lf = import ./lf context;

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      color = "always";
    };
  };


  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
    };
  };

  programs.home-manager.enable = true;
}
