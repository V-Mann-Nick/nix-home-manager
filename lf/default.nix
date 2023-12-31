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
  programs.lf = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "lf-wrapped";
      paths = [pkgs.lf];
      postBuild = let
        icons = import ./icons.nix;
        setToEnvVar = set: lib.concatStringsSep ":" (lib.attrValues (lib.mapAttrs (ext: icon: "${ext}=${icon}") set));
        iconEnvVar = setToEnvVar icons;
        binWrapped = pkgs.writeShellScript "lf-wrapped" ''
          LF_ICONS="${iconEnvVar}" ${pkgs.lf}/bin/lf "$@"
        '';
      in ''
        rm $out/bin/lf
        ln -s ${binWrapped} $out/bin/lf
      '';
    };
    settings = {
      drawbox = true;
      icons = true;
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
    extraConfig = let
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
    in ''
      set previewer ${previewer}/bin/lf-previewer
      set cleaner ${previewCleaner}/bin/lf-preview-cleaner
    '';
  };
}
