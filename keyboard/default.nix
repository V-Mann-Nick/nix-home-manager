{config, ...}: {
  home.file.xkb = {
    enable = true;
    recursive = true;
    source = ./xkb;
    target = "${config.xdg.configHome}/xkb";
  };
}
