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
      dconf2nix
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
