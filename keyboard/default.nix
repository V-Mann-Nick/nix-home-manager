{...}: {
  xdg.configFile.xkb = {
    enable = true;
    recursive = true;
    source = ./xkb;
    target = "xkb";
  };
}
