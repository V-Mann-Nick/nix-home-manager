{
  pkgs,
  theme,
  ...
}: let
  # Overlay nixpkgs.gradience to get newer version supporting shell theming
  # and patch the source code to make the shell theming code work:
  #   - remove all the checks for user-theme extension
  #   - when shell theme templates are copied change permissions to be writable
  #   - remove step to set the shell theme - we're only want to generate it here
  # All in all this is a super hacky way to generate the themes using Gradience.
  # !!!Caution when updating Gradience - this patch will probably need to be updated.!!!
  gradiencePkgs = with pkgs;
    extend (_: prev: {
      gradience = prev.gradience.overrideAttrs (old: {
        version = "0.8.0-beta1";
        propagatedBuildInputs = old.propagatedBuildInputs ++ [python3Packages.libsass];
        src = prev.fetchgit {
          url = "https://github.com/GradienceTeam/Gradience.git";
          rev = "06b83cee3b84916ab9812a47a84a28ca43c8e53f";
          sha256 = "sha256-gdY5QG0STLHY9bw5vI49rY6oNT8Gg8oxqHeEbqM4XfM=";
          fetchSubmodules = true;
        };
        patches = (old.patches or []) ++ [./gradience.patch];
      });
    });
  # Stub the gnome-shell binary to satisfy the check without downloading Gnome
  gnomeShellStub = pkgs.writeShellScriptBin "gnome-shell" ''
    echo "GNOME Shell 45.2"
  '';
  gradienceBuild = pkgs.stdenv.mkDerivation {
    name = "gradience-build";
    preset = builtins.toJSON theme.gnome;
    passAsFile = ["preset"];
    phases = ["buildPhase" "installPhase"];
    nativeBuildInputs = [gnomeShellStub];
    buildPhase = ''
      export HOME=$TMPDIR
      export XDG_CURRENT_DESKTOP=GNOME
      mkdir -p $HOME/.config/presets
      ${gradiencePkgs.gradience}/bin/gradience-cli apply -p $presetPath --gtk both
      ${gradiencePkgs.gradience}/bin/gradience-cli gnome-shell -p $presetPath -v dark
    '';
    installPhase = ''
      mkdir -p $out
      cp -r .config/gtk-4.0 $out/
      cp -r .config/gtk-3.0 $out/
      cp -r .local/share/themes/gradience-shell $out/
    '';
  };
  shellTheme = "gradience-shell";
in {
  # ??? I believe that adw-gtk3 is currently an implicit dependency installed with pacman ???
  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    iconTheme = theme.gtkIcons;
    gtk3 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
      extraCss = builtins.readFile "${gradienceBuild}/gtk-3.0/gtk.css";
    };
    gtk4 = {
      extraConfig = {
        "gtk-application-prefer-dark-theme" = 1;
      };
      extraCss = builtins.readFile "${gradienceBuild}/gtk-4.0/gtk.css";
    };
  };
  home.packages = [pkgs.gnomeExtensions.user-themes];
  home.pointerCursor.gtk.enable = true;
  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = shellTheme;
    };
    "org/gnome/shell" = {
      enabled-extensions = [pkgs.gnomeExtensions.user-themes.extensionUuid];
    };
  };
  xdg.dataFile.shellTheme = {
    enable = true;
    recursive = true;
    source = "${gradienceBuild}/gradience-shell";
    target = "themes/${shellTheme}";
  };
}
