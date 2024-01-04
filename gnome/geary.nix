{
  pkgs,
  helpers,
  theme,
  ...
}: {
  home.packages = [pkgs.gnome.geary];
  # https://www.reddit.com/r/gnome/comments/xn5pk6/comment/ipt5vzs/?utm_source=share&utm_medium=web2x&context=3
  xdg.configFile.gearyCustomCss = {
    enable = true;
    source = let
      templateVariables = with theme.gnome.variables; {
        background_color = view_bg_color;
        text_color = view_fg_color;
      };
      gearyCustomCss = helpers.templateFile "user-style.css" ./geary.css templateVariables;
    in "${gearyCustomCss}/user-style.css";
    target = "geary/user-style.css";
  };
}
