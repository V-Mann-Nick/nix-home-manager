{
  pkgs,
  hasMonoLisa,
  config,
  theme,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    # Fix EGL error on non-NixOS system (Arch):
    # https://github.com/NixOS/nixpkgs/issues/122671#issuecomment-839399163
    package = pkgs.symlinkJoin {
      name = "kitty-wrapped";
      paths = [pkgs.kitty];
      postBuild = let
        binWrapped = pkgs.writeShellScript "kitty-bin-wrapped" ''
          ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.kitty}/bin/kitty
        '';
      in ''
        rm $out/bin/kitty
        ln -s ${binWrapped} $out/bin/kitty
      '';
    };
    font =
      if hasMonoLisa
      then {
        name = "MonoLisa";
        size = 12;
      }
      else null;
    keybindings = {
      "kitty_mod+t" = "new_tab";
      "kitty_mod+j" = "next_window";
      "kitty_mod+k" = "previous_window";
      "map" = "kitty_mod+q no_op";
      "kitty_mod+shift+q" = "close_window";
      "kitty_mod+shift+z" = "resize_window narrower";
      "kitty_mod+shift+o" = "resize_window wider";
      "kitty_mod+shift+i" = "resize_window taller";
      "kitty_mod+shift+u" = "resize_window shorter 3";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "kitty_mod+," = "previous_tab";
      "kitty_mod+." = "next_tab";
      "kitty_mod+shift+," = "move_tab_backward";
      "kitty_mod+shift+." = "move_tab_forward";
      "kitty_mod+enter" = "new_window_with_cwd";
      "kitty_mod+shift+enter" = "move_window_to_top";
      "kitty_mod+shift+k" = "move_window_backward";
      "kitty_mod+shift+j" = "move_window_forward";
      "kitty_mod+h" = "no_op";
      "kitty_mod+q" = "no_op";
      "kitty_mod+e" = "no_op";
      "kitty_mod+shift+d" = "detach_window ask";
    };
    settings =
      {
        allow_remote_control = "yes";
        draw_minimal_borders = "no";
        enabled_layouts = "tall,grid,stack";
        window_padding_width = "8 8";
        kitty_mod = "alt";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        confirm_os_window_close = "0";
        background_opacity = "0.95";
        hide_window_decorations = "yes";
        wayland_titlebar_color = "background";
        enable_audio_bell = "no";
        shell = "${config.programs.zsh.package}/bin/zsh";
        placement_strategy = "top-left";
        # linux_display_server = "x11";
        symbol_map = ''
          U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font Mono
        '';
      }
      // theme.kitty;
  };
}
