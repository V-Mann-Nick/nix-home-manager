{
  config,
  pkgs,
  lib,
  theme,
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
      ./gnome
      ./theme
      ./firefox
      ./dotfiles
    ]
    ++ (
      if lib.pathExists ./extension.nix
      then [./extension.nix]
      else []
    );

  nixpkgs.config = {
    allowUnfree = true;
  };

  manual.html.enable = true;

  targets.genericLinux.enable = true;

  home = rec {
    username = "nicklas";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";

    language = let
      en = "en_US.UTF-8";
      de = "de_DE.UTF-8";
    in {
      base = en;
      address = de;
      numeric = de;
      time = de;
      monetary = de;
      paper = de;
      name = en;
      telephone = de;
      measurement = de;
      collate = en;
      ctype = en;
    };

    sessionVariables = {
      TERMINAL = "kitty";
      BROWSER = "firefox";
      VISUAL = "nvim";

      # Podman auth
      REGISTRY_AUTH_FILE = "${config.xdg.configHome}/containers/auth.json";
    };

    sessionPath = [
      "${homeDirectory}/.local/bin"
    ];

    packages = with pkgs; [
      # Show system info
      neofetch

      # OCI container runtime
      podman

      # Compose for podman
      podman-compose

      # Clipboard utility for Wayland
      wl-clipboard

      # System monitor
      htop

      # CLI for putting files into trash
      trash-cli

      # JSON utility
      jq

      # Shell scripting analysis
      shellcheck

      # Bonsai <3
      cbonsai

      # Terminal image editor
      imagemagick

      # Bäähh
      vscode

      # Infrastructure as code language
      terraform

      # Node for Typescript files
      nodePackages.ts-node

      # Analyze OCI containers
      dive

      # Github CLI
      gh

      # Better python REPL
      python311Packages.ipython

      # Convert dconf dump to nix expression
      dconf2nix

      # For xdg-open with nix apps - needed for firefox to open links (other apps maybe too)
      xdg-utils
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

    pointerCursor = theme.cursors;
  };

  programs.bat = {
    enable = true;
    config = {
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

  programs.ripgrep.enable = true;

  programs.home-manager.enable = true;
}
