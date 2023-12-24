{
  pkgs,
  lib,
  ...
}: let
  extensions = with pkgs.gnomeExtensions; [
    {
      pkg = vitals;
      config = {
        "org/gnome/shell/extensions/vitals" = {
          fixed-widths = true;
          hide-icons = false;
          hot-sensors = ["__temperature_avg__" "_memory_allocated_" "_processor_usage_"];
          position-in-panel = 0;
          show-battery = false;
          update-time = 10;
          use-higher-precision = false;
        };
      };
    }
    {
      pkg = archlinux-updates-indicator;
      config = {
        "org/gnome/shell/extensions/arch-update" = {
          check-cmd = "/bin/sh -c \"checkupdates && yay -Qum\"";
          check-interval = 30;
          update-cmd = "kitty -- /bin/sh -c \"yay -Syu ; echo Done - Press enter to exit; read _\" ";
          use-buildin-icons = false;
        };
      };
    }
    {
      pkg = user-themes;
      config = {
        "org/gnome/shell/extensions/user-theme" = {
          name = "gradience-shell";
        };
      };
    }
    {pkg = screenshot-window-sizer;}
    {pkg = removable-drive-menu;}
    {pkg = native-window-placement;}
    {
      pkg = quick-settings-tweaker;
      config = {
        "org/gnome/shell/extensions/quick-settings-tweaks" = {
          add-unsafe-quick-toggle-enabled = false;
          datemenu-remove-media-control = true;
          disable-remove-shadow = false;
          input-always-show = false;
          input-show-selected = true;
          last-unsafe-state = false;
          list-buttons = "[{\"name\":\"SystemItem\",\"title\":null,\"visible\":true},{\"name\":\"OutputStreamSlider\",\"title\":null,\"visible\":true},{\"name\":\"InputStreamSlider\",\"title\":null,\"visible\":false},{\"name\":\"St_BoxLayout\",\"title\":null,\"visible\":true},{\"name\":\"BrightnessItem\",\"title\":null,\"visible\":false},{\"name\":\"NMWiredToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMWirelessToggle\",\"title\":\"Wi-Fi\",\"visible\":true},{\"name\":\"NMModemToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMBluetoothToggle\",\"title\":null,\"visible\":false},{\"name\":\"NMVpnToggle\",\"title\":null,\"visible\":false},{\"name\":\"BluetoothToggle\",\"title\":\"Bluetooth\",\"visible\":true},{\"name\":\"PowerProfilesToggle\",\"title\":\"Power Mode\",\"visible\":true},{\"name\":\"NightLightToggle\",\"title\":\"Night Light\",\"visible\":true},{\"name\":\"DarkModeToggle\",\"title\":\"Dark Style\",\"visible\":true},{\"name\":\"KeyboardBrightnessToggle\",\"title\":\"Keyboard\",\"visible\":true},{\"name\":\"RfkillToggle\",\"title\":\"Airplane Mode\",\"visible\":true},{\"name\":\"RotationToggle\",\"title\":\"Auto Rotate\",\"visible\":false},{\"name\":\"DndQuickToggle\",\"title\":\"Do Not Disturb\",\"visible\":true},{\"name\":\"BackgroundAppsToggle\",\"title\":\"No Background Apps\",\"visible\":false},{\"name\":\"MediaSection\",\"title\":null,\"visible\":false},{\"name\":\"Notifications\",\"title\":null,\"visible\":false}]";
          notifications-enabled = true;
          notifications-hide-when-no-notifications = true;
          output-show-selected = true;
          volume-mixer-enabled = true;
          volume-mixer-position = "top";
        };
      };
    }
    {pkg = gsconnect;}
    {
      pkg = just-perfection;
      config = {
        "org/gnome/shell/extensions/just-perfection" = {
          accessibility-menu = true;
          activities-button = true;
          aggregate-menu = true;
          app-menu = true;
          app-menu-icon = true;
          app-menu-label = true;
          background-menu = true;
          clock-menu = true;
          controls-manager-spacing-size = 0;
          dash = false;
          dash-icon-size = 0;
          dash-separator = true;
          double-super-to-appgrid = true;
          events-button = true;
          gesture = true;
          hot-corner = false;
          keyboard-layout = true;
          osd = true;
          panel = true;
          panel-arrow = true;
          panel-corner-size = 0;
          panel-in-overview = true;
          panel-notification-icon = true;
          panel-size = 0;
          power-icon = true;
          ripple-box = true;
          screen-sharing-indicator = true;
          search = true;
          show-apps-button = true;
          startup-status = 0;
          theme = false;
          weather = true;
          window-demands-attention-focus = false;
          window-picker-icon = true;
          window-preview-caption = true;
          window-preview-close-button = true;
          workspace = true;
          workspace-background-corner-size = 0;
          workspace-popup = false;
          workspace-switcher-should-show = false;
          workspaces-in-app-grid = true;
          world-clock = true;
        };
      };
    }
    {pkg = hibernate-status-button;}
    {
      pkg = appindicator;
      config = {
        "org/gnome/shell/extensions/appindicator" = {
          legacy-tray-enabled = true;
        };
      };
    }
    {pkg = quick-lang-switch;}
    {pkg = swap-finger-gestures-3-to-4;}
    {
      pkg = runcat;
      config = {
        "org/gnome/shell/extensions/runcat" = {
          displaying-items = "character-only";
          idle-threshold = 5;
        };
      };
    }
    {pkg = primary-input-on-lockscreen;}
    {pkg = noannoyance-fork;}
    {pkg = user-avatar-in-quick-settings;}
    {pkg = battery-time;}
    {pkg = autohide-battery;}
    {
      pkg = blur-my-shell;
      config = {
        "org/gnome/shell/extensions/blur-my-shell/applications" = {
          whitelist = ["kitty"];
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          blur = true;
          brightness = 0.25;
          customize = true;
          override-background-dynamically = false;
          style-panel = 2;
        };
      };
    }
  ];
  packages = map (e: e.pkg) extensions;
  uuids = map (p: p.extensionUuid) packages;
  mergedConfigs = with lib; let
    configs = map (e:
      if e ? config
      then e.config
      else {})
    extensions;
    merge = attrList:
      if attrList == []
      then {}
      else (merge (tail attrList)) // (head attrList);
  in
    merge configs;
in {
  home.packages = packages;
  dconf.settings =
    {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = uuids;
      };
    }
    // mergedConfigs;
}
