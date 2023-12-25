{lib, ...}: let
  monoLisaPath = ./ttf;
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
}
