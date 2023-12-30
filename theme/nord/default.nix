{
  pkgs,
  helpers,
  ...
}: let
  theme = {
    gtkIcons = {
      name = "Papirus-Dark";
      package = pkgs.papirus-nord;
    };
    cursors = {
      name = "Nordzy-cursors";
      package = pkgs.nordzy-cursor-theme;
    };
    gnome = {
      name = "Nord Dark";
      variables = {
        accent_color = "rgb(136,192,208)";
        accent_bg_color = "rgb(136,192,208)";
        accent_fg_color = "rgb(46,52,64)";
        destructive_color = "rgb(208,135,112)";
        destructive_bg_color = "rgb(208,135,112)";
        destructive_fg_color = "rgb(46,52,64)";
        success_color = "rgb(163,190,140)";
        success_bg_color = "rgb(163,190,140)";
        success_fg_color = "rgb(46,52,64)";
        warning_color = "rgb(235,203,139)";
        warning_bg_color = "rgb(235,203,139)";
        warning_fg_color = "rgb(46,52,64)";
        error_color = "rgb(191,97,106)";
        error_bg_color = "rgb(191,97,106)";
        error_fg_color = "rgb(46,52,64)";
        window_bg_color = "rgb(46,52,64)";
        window_fg_color = "rgb(236,239,244)";
        view_bg_color = "rgb(59,66,82)";
        view_fg_color = "rgb(236,239,244)";
        headerbar_bg_color = "rgb(59,66,82)";
        headerbar_fg_color = "rgb(236,239,244)";
        headerbar_border_color = "rgb(59,66,82)";
        headerbar_backdrop_color = "rgb(46,52,64)";
        headerbar_shade_color = "rgb(59,66,82)";
        card_bg_color = "rgb(46,52,64)";
        card_fg_color = "rgb(236,239,244)";
        card_shade_color = "rgb(59,66,82)";
        dialog_bg_color = "rgb(67,76,94)";
        dialog_fg_color = "rgb(236,239,244)";
        popover_bg_color = "rgb(67,76,94)";
        popover_fg_color = "rgb(236,239,244)";
        shade_color = "rgb(59,66,82)";
        scrollbar_outline_color = "rgb(229,233,240)";
        sidebar_bg_color = "rgb(59,66,82)";
        sidebar_fg_color = "rgb(236,239,244)";
        sidebar_backdrop_color = "rgb(46,52,64)";
        sidebar_shade_color = "rgb(59,66,82)";
        secondary_sidebar_bg_color = "rgb(59,66,82)";
        secondary_sidebar_fg_color = "rgb(236,239,244)";
        secondary_sidebar_backdrop_color = "rgb(46,52,64)";
        secondary_sidebar_shade_color = "rgb(59,66,82)";
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
        gtk4 = "";
        gtk3 = "";
      };
      plugins = {};
    };
    neovim = {
      lualine = "nordfox";
      theme = {
        plugin = pkgs.vimPlugins.nightfox-nvim;
        config = helpers.templateSourceLua "nightfox-nvim-config" ./nightfox-nvim.lua {};
      };
    };
    # Nightfox (Nordfox) colors for Kitty
    kitty = {
      background = "#2e3440";
      foreground = "#cdcecf";
      selection_background = "#3e4a5b";
      selection_foreground = "#cdcecf";
      cursor_text_color = "#2e3440";
      url_color = "#a3be8c";
      cursor = "#cdcecf";

      # Border
      active_border_color = "#81a1c1";
      inactive_border_color = "#5a657d";
      bell_border_color = "#c9826b";

      # Tabs
      active_tab_background = "#81a1c1";
      active_tab_foreground = "#232831";
      inactive_tab_background = "#3e4a5b";
      inactive_tab_foreground = "#60728a";

      # normal
      color0 = "#3b4252";
      color1 = "#bf616a";
      color2 = "#a3be8c";
      color3 = "#ebcb8b";
      color4 = "#81a1c1";
      color5 = "#b48ead";
      color6 = "#88c0d0";
      color7 = "#e5e9f0";

      # bright
      color8 = "#465780";
      color9 = "#d06f79";
      color10 = "#b1d196";
      color11 = "#f0d399";
      color12 = "#8cafd2";
      color13 = "#c895bf";
      color14 = "#93ccdc";
      color15 = "#e7ecf4";

      # extended colors
      color16 = "#c9826b";
      color17 = "#bf88bc";
    };
  };
in {
  _module.args = {
    inherit theme;
  };
  programs.bat.config.theme = "Nord";
}
