{
  lib,
  pkgs,
  ...
}: let
  monoLisaPath = ./ttf-mono-lisa;
  hasMonoLisa = lib.pathExists monoLisaPath;
in {
  _module.args = {
    inherit hasMonoLisa;
  };

  xdg.dataFile.monoLisa = {
    enable = hasMonoLisa;
    recursive = true;
    source = monoLisaPath;
    target = "fonts/MonoLisa";
    onChange = "fc-cache -f -v";
  };

  fonts.fontconfig.enable = true;

  nixpkgs.config.joypixels.acceptLicense = true;
  home.packages = with pkgs; [
    joypixels
    (nerdfonts.override {
      fonts = ["NerdFontsSymbolsOnly"];
    })
    ubuntu_font_family
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" =
      {
        font-name = "Ubuntu 11";
        document-font-name = "Ubuntu 11";
        font-antialiasing = "rgba";
      }
      // (
        if hasMonoLisa
        then {
          monospace-font-name = "MonoLisa 11";
        }
        else {
          monospace-font-name = "Ubuntu Mono 11";
        }
      );
    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Ubuntu Bold 11";
    };
  };

  xdg.configFile.fontConfig = {
    enable = true;
    source = ./75-joypixels.xml;
    target = "fontconfig/conf.d/75-joypixels.conf";
    onChange = "fc-cache -f -v";
  };
}
