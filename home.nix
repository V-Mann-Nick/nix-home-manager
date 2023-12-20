{
  config,
  pkgs,
  lib,
  ...
}: {
  imports =
    [
      ./lf
      ./direnv
      ./favorite-dirs.nix
      ./lib.nix
      ./mono-lisa
      ./kitty
      ./git
      ./starship
      ./zsh
      ./neovim
      ./keyboard
      ./gnome-theme
    ]
    ++ (
      if lib.pathExists ./extension.nix
      then [./extension.nix]
      else []
    );

  nixpkgs.config = {
    allowUnfree = true;
  };

  home = rec {
    username = "nicklas";
    homeDirectory = "/home/${username}";
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
    ];

    packages = with pkgs; [
      neofetch
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
      vscode
      scc
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
      dive
      gh
      python311Packages.ipython
    ];
    shellAliases = {
      sw = "home-manager switch";
      pc = "podman-compose";
      "sensible-editor" = "$EDITOR";
      c = "nvim .";
      py = "poetry";
      ipv = "ipython --TerminalInteractiveShell.editing_mode=vi";
      n = "pnpm";
      D = "trash-put";
      p = "sudo pacman";
    };

    file.poetry = {
      enable = true;
      target = "${config.xdg.configHome}/pypoetry/config.toml";
      text = builtins.readFile ./dotfiles/poetry-config.toml;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      color = "always";
    };
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
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
