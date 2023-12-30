{
  pkgs,
  helpers,
  ...
}: let
  theme = {
    gtkIcons = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "macchiato";
        accent = "flamingo";
      };
    };
    cursors = {
      name = "Catppuccin-Macchiato-Dark-Cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
    gnome = {
      name = "Catppuccin Macchiato";
      variables = {
        accent_color = "rgb(125, 196, 228)";
        accent_bg_color = "rgb(138, 173, 244)";
        accent_fg_color = "rgb(24, 25, 38)";
        destructive_color = "rgb(238, 153, 160)";
        destructive_bg_color = "rgb(237, 135, 150)";
        destructive_fg_color = "rgb(24, 25, 38)";
        success_color = "rgb(166, 218, 149)";
        success_bg_color = "rgb(139, 213, 202)";
        success_fg_color = "rgb(24, 25, 38)";
        warning_color = "rgb(245, 169, 127)";
        warning_bg_color = "rgb(238, 212, 159)";
        warning_fg_color = "rgb(24, 25, 38)";
        error_color = "rgb(238, 153, 160)";
        error_bg_color = "rgb(237, 135, 150)";
        error_fg_color = "rgb(24, 25, 38)";
        window_bg_color = "rgb(36, 39, 58)";
        window_fg_color = "rgb(202, 211, 245)";
        view_bg_color = "rgb(30, 32, 48)";
        view_fg_color = "rgb(202, 211, 245)";
        headerbar_bg_color = "rgb(24, 25, 38)";
        headerbar_fg_color = "rgb(202, 211, 245)";
        headerbar_border_color = "rgb(110, 115, 141)";
        headerbar_backdrop_color = "rgb(36, 39, 58)";
        headerbar_shade_color = "rgba(0, 0, 0, 0.36)";
        card_bg_color = "rgb(30, 32, 48)";
        card_fg_color = "rgb(202, 211, 245)";
        card_shade_color = "rgba(0, 0, 0, 0.36)";
        dialog_bg_color = "rgb(30, 32, 48)";
        dialog_fg_color = "rgb(202, 211, 245)";
        popover_bg_color = "rgb(30, 32, 48)";
        popover_fg_color = "rgb(202, 211, 245)";
        shade_color = "rgba(0,0,0,0.36)";
        scrollbar_outline_color = "rgba(0,0,0,0.5)";
        sidebar_bg_color = "rgb(46,52,64)";
        sidebar_fg_color = "rgb(202, 211, 245)";
        sidebar_backdrop_color = "rgb(36, 39, 58)";
        sidebar_shade_color = "rgba(0, 0, 0, 0.36)";
        secondary_sidebar_bg_color = "rgb(46,52,64)";
        secondary_sidebar_fg_color = "rgb(202, 211, 245)";
        secondary_sidebar_backdrop_color = "rgb(36, 39, 58)";
        secondary_sidebar_shade_color = "rgba(0, 0, 0, 0.36)";
      };
      palette = {
        blue_ = {
          "1" = "#99c1f1";
          "2" = "#62a0ea";
          "3" = "#3584e4";
          "4" = "#1c71d8";
          "5" = "#1a5fb4";
        };
        green_ = {
          "1" = "#8ff0a4";
          "2" = "#57e389";
          "3" = "#33d17a";
          "4" = "#2ec27e";
          "5" = "#26a269";
        };
        yellow_ = {
          "1" = "#f9f06b";
          "2" = "#f8e45c";
          "3" = "#f6d32d";
          "4" = "#f5c211";
          "5" = "#e5a50a";
        };
        orange_ = {
          "1" = "#ffbe6f";
          "2" = "#ffa348";
          "3" = "#ff7800";
          "4" = "#e66100";
          "5" = "#c64600";
        };
        red_ = {
          "1" = "#f66151";
          "2" = "#ed333b";
          "3" = "#e01b24";
          "4" = "#c01c28";
          "5" = "#a51d2d";
        };
        purple_ = {
          "1" = "#dc8add";
          "2" = "#c061cb";
          "3" = "#9141ac";
          "4" = "#813d9c";
          "5" = "#613583";
        };
        brown_ = {
          "1" = "#cdab8f";
          "2" = "#b5835a";
          "3" = "#986a44";
          "4" = "#865e3c";
          "5" = "#63452c";
        };
        light_ = {
          "1" = "#ffffff";
          "2" = "#f6f5f4";
          "3" = "#deddda";
          "4" = "#c0bfbc";
          "5" = "#9a9996";
        };
        dark_ = {
          "1" = "#77767b";
          "2" = "#5e5c64";
          "3" = "#3d3846";
          "4" = "#241f31";
          "5" = "#000000";
        };
      };
      custom_css = {
        "gtk4" = "";
        "gtk3" = "";
      };
      plugins = {};
    };
    neovim = {
      lualine = "catppuccin";
      theme = {
        plugin = pkgs.vimPlugins.catppuccin-nvim;
        config = helpers.templateSourceLua "catppuccin-config" ./catppuccin-macchiato.lua {};
      };
    };
    # Catppuccin Maccchiato colors for kitty
    kitty = {
      foreground = "#CAD3F5";
      background = "#24273A";
      selection_foreground = "#24273A";
      selection_background = "#F4DBD6";
      cursor = "#F4DBD6";
      cursor_text_color = "#24273A";
      url_color = "#F4DBD6";
      active_border_color = "#B7BDF8";
      inactive_border_color = "#6E738D";
      bell_border_color = "#EED49F";
      active_tab_foreground = "#181926";
      active_tab_background = "#C6A0F6";
      inactive_tab_foreground = "#CAD3F5";
      inactive_tab_background = "#1E2030";
      tab_bar_background = "#181926";
      mark1_foreground = "#24273A";
      mark1_background = "#B7BDF8";
      mark2_foreground = "#24273A";
      mark2_background = "#C6A0F6";
      mark3_foreground = "#24273A";
      mark3_background = "#7DC4E4";
      color0 = "#494D64";
      color8 = "#5B6078";
      color1 = "#ED8796";
      color9 = "#ED8796";
      color2 = "#A6DA95";
      color10 = "#A6DA95";
      color3 = "#EED49F";
      color11 = "#EED49F";
      color4 = "#8AADF4";
      color12 = "#8AADF4";
      color5 = "#F5BDE6";
      color13 = "#F5BDE6";
      color6 = "#8BD5CA";
      color14 = "#8BD5CA";
      color7 = "#B8C0E0";
      color15 = "#A5ADCB";
    };
  };
in {
  _module.args = {
    inherit theme;
  };
  programs.bat = let
    themeName = "catppuccin";
  in {
    themes = {
      ${themeName} = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-macchiato.tmTheme";
      };
    };
    config = {
      theme = themeName;
    };
  };
}
