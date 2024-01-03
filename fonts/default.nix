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
  ];

  xdg.configFile.fontConfig = {
    enable = true;
    source = ./75-joypixels.xml;
    target = "fontconfig/conf.d/75-joypixels.conf";
    onChange = "fc-cache -f -v";
  };
}
