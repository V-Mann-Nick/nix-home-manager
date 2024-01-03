{
  config,
  pkgs,
  helpers,
  theme,
  ...
}: let
  firefoxGnomeTheme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    rev = "v121";
    sha256 = "sha256-M+Cw6vh7xCDmIhyVuEPNmaNVUwpmdFQq8zlsXZTKees=";
  };
  profileName = "nicklas";
  profileDir = "${config.home.homeDirectory}/.mozilla/firefox/${profileName}";
in {
  programs.firefox = {
    enable = true;
    # Don't install firefox - installed via pacman
    package = null;
    profiles = {
      ${profileName} = {
        extensions = with config.nur.repos.rycee.firefox-addons; [
          ublock-origin
          sponsorblock
          tabliss
          i-dont-care-about-cookies
        ];
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
        extraConfig = builtins.readFile "${firefoxGnomeTheme}/configuration/user.js";
        settings = {
          "gnomeTheme.normalWidthTabs" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.translations.neverTranslateLanguages" = "en,de";
          # https://wiki.archlinux.org/title/Firefox#Font_troubleshooting
          "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
          "gfx.font_rendering.opentype_svg.enabled" = false;
          "font.name.serif.x-western" = "Ubuntu";
          "font.name.sans-serif.x-western" = "Ubuntu";
          "font.name.monospace.x-western" = "MonoLisa";
        };
      };
    };
  };
  home.file.firefoxGnomeTheme = {
    enable = true;
    recursive = true;
    source = pkgs.symlinkJoin {
      name = "firefox-gnome-theme";
      paths = [
        firefoxGnomeTheme
        (helpers.templateFile "customChrome.css" ./custom-chrome.css theme.gnome.variables)
      ];
    };
    target = "${profileDir}/chrome/firefox-gnome-theme";
  };
}
