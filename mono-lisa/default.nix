{
  lib,
  config,
  ...
}: let
  monoLisaPath = ./ttf;
  hasMonoLisa = lib.pathExists monoLisaPath;
in {
  _module.args = {
    inherit hasMonoLisa;
  };

  home.file.monoLisa = {
    enable = hasMonoLisa;
    recursive = true;
    source = monoLisaPath;
    target = "${config.xdg.dataHome}/fonts/MonoLisa";
    onChange = "fc-cache -f -v";
  };
}
