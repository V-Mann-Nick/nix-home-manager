{
  pkgs,
  lib,
  config,
  ...
}: {
  home.shellAliases = {
    l = let
      lfcd = pkgs.writeText "lfcd-source" (builtins.readFile ./lfcd.sh);
    in "source ${lfcd} && lfcdFn";
  };
  xdg.configFile.lfIcons = {
    enable = true;
    source = ./icons;
    target = "lf/icons";
  };
  programs.lf = {
    enable = true;
    settings = let
      previewer = pkgs.writeShellApplication {
        name = "lf-previewer";
        runtimeInputs = with pkgs; [
          config.programs.kitty.package
          coreutils
          gawk
          gnutar
          xz
          unzip
          unrar
          glow
          libcdio
          odt2txt
          catdoc
          catdocx
          poppler_utils
          ffmpegthumbnailer
          bat
        ];
        text = builtins.readFile ./previewer.sh;
      };
      previewCleaner = pkgs.writeShellApplication {
        name = "lf-preview-cleaner";
        runtimeInputs = [config.programs.kitty.package];
        text = builtins.readFile ./preview-cleaner.sh;
      };
    in {
      drawbox = true;
      icons = true;
      previewer = "${previewer}/bin/lf-previewer";
      cleaner = "${previewCleaner}/bin/lf-preview-cleaner";
    };
    keybindings = let
      aliasesCd = builtins.listToAttrs (lib.mapAttrsToList (alias: path: {
          name = "g${alias}";
          value = "cd ${path}";
        })
        config._module.args.aliases);
    in
      {
        "D" = ''
          $IFS=''\"$(printf ''\'''\\n''\\t''\')''\"; ${pkgs.trash-cli}/bin/trash-put -- $fx
        '';
        "C" = "push $touch<space>";
        "M" = "push $mkdir<space>";
        "<backspace>" = "set hidden!";
        "<backspace2>" = "set hidden!";
      }
      // aliasesCd;
  };
}
