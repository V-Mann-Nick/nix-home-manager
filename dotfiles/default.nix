{...}: {
  xdg.configFile.poetry = {
    enable = true;
    target = "pypoetry/config.toml";
    text = builtins.readFile ./poetry-config.toml;
  };
}
