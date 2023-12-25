{
  config,
  lib,
  ...
}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [(mkTuple ["xkb" "zy"]) (mkTuple ["xkb" "de"])];
      sources = [(mkTuple ["xkb" "zy"]) (mkTuple ["xkb" "de"])];
      xkb-options = ["caps:escape"];
    };

    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      clock-show-date = true;
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      enable-animations = true;
      enable-hot-corners = false;
      font-antialiasing = "rgba";
      font-hinting = "full";
      font-name = "Cantarell 11";
      gtk-theme = "adw-gtk3";
      icon-theme = "Adwaita";
      monospace-font-name = "MonoLisa 11";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      begin-move = [];
      begin-resize = [];
      close = ["<Shift><Super>q"];
      move-to-monitor-down = [];
      move-to-monitor-left = [];
      move-to-monitor-right = [];
      move-to-monitor-up = [];
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
      move-to-workspace-5 = ["<Super><Shift>5"];
      move-to-workspace-6 = ["<Super><Shift>6"];
      move-to-workspace-7 = ["<Super><Shift>7"];
      move-to-workspace-last = [];
      move-to-workspace-left = [];
      move-to-workspace-right = [];
      switch-panels = [];
      switch-panels-backward = [];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-last = [];
      switch-to-workspace-left = [];
      switch-to-workspace-right = [];
      toggle-fullscreen = ["<Shift><Super>f"];
      toggle-maximized = ["<Super>f"];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      switch-to-application-5 = [];
      switch-to-application-6 = [];
      switch-to-application-7 = [];
      switch-to-application-8 = [];
      switch-to-application-9 = [];
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [];
      toggle-tiled-right = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "${config.programs.kitty.package}/bin/kitty";
      name = "Kitty";
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}
