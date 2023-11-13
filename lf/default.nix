{ pkgs, lib, aliases, ... }:
let 
  bashShebang = "#!${pkgs.bash}/bin/bash";
  cleanerPackage = pkgs.writeScriptBin "cleaner.sh" ''
    ${bashShebang}
    if [ -n "$KITTY_WINDOW_ID" ]; then
      kitten icat --clear --silent --transfer-mode file --stdin no < /dev/null > /dev/tty
    fi
  '';
  cleaner = "${cleanerPackage}/bin/cleaner.sh";
  previewerPackage = pkgs.writeScriptBin "pv.sh" ''
    ${bashShebang}
    w=$2
    h=$3
    x=$4
    y=$5

    # Check if current terminal is kitty by checking KITTY_WINDOW_ID env var
    if [ -n "$KITTY_WINDOW_ID" ]; then
      image() {
        kitten icat --silent --transfer-mode file --stdin no --place "''${w}x''${h}@''${x}x''${y}" "$1" < /dev/null > /dev/tty
      }
    else
      image() {
        echo "IMAGE PREVIEW NOT SUPPORTED"
      }
    fi


    CACHE_DIR="$HOME/.cache/lf"
    mkdir -p "$CACHE_DIR"
    CACHE="$CACHE_DIR/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}'))"

    case "$(printf "%s\n" "$(readlink -f "$1")" | awk '{print tolower($0)}')" in
      *.tgz|*.tar.gz) ${pkgs.gnutar}/bin/tar tzf "$1" ;;
      *.tar.bz2|*.tbz2) ${pkgs.gnutar}/bin/tar tjf "$1" ;;
      *.tar.txz|*.txz) ${pkgs.xz}/bin/xz --list "$1" ;;
      *.tar) ${pkgs.gnutar}/bin/tar tf "$1" ;;
      *.zip|*.jar|*.war|*.ear|*.oxt) ${pkgs.unzip}/bin/unzip -l "$1" ;;
      *.rar) ${pkgs.unrar}/bin/unrar l "$1" ;;
      *.md) ${pkgs.glow}/bin/glow "$1";;
      *.iso) ${pkgs.libcdio}/bin/iso-info --no-header -l "$1" ;;
      *.odt|*.ods|*.odp|*.sxw) ${pkgs.odt2txt}/bin/odt2txt "$1" ;;
      *.doc) ${pkgs.catdoc}/bin/catdoc "$1" ;;
      *.docx) ${pkgs.catdocx}/bin/catdocx "$1" ;;
      *.pdf)
          [ ! -f "''${CACHE}.jpg" ] && \
            ${pkgs.poppler_utils}/bin/pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
          image "''${CACHE}.jpg"
          ;;
      *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
          [ ! -f "''${CACHE}.jpg" ] && \
            ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -i "$1" -o "''${CACHE}.jpg" -s 0 -q 5
          image "''${CACHE}.jpg"
          ;;
      *.bmp|*.jpg|*.jpeg|*.png|*.xpm|*.webp|*.tiff|*.gif|*.jfif|*.ico|*.svg) image "$1" ;;
      *) ${pkgs.bat}/bin/bat --terminal-width "$(($2-2))" --wrap character --pager never --style numbers "$1" ;;
    esac
    exit 1
  '';
  previewer = "${previewerPackage}/bin/pv.sh";
  lfPackage = pkgs.lf;
  lf = "${lfPackage}/bin/lf";
  icons = import ./icons.nix;
  setToEnvVar = set: lib.concatStringsSep ":" (lib.attrValues (lib.mapAttrs (ext: icon: "${ext}=${icon}") set));
  iconEnvVar = setToEnvVar icons;
  aliasesCd = builtins.listToAttrs (lib.mapAttrsToList (alias: path: { name = "g${alias}"; value = "cd ${path}"; }) aliases);
  package = pkgs.writeScriptBin "lf" ''
    ${bashShebang}
    LF_ICONS="${iconEnvVar}" ${lf} "$@"
  '';
in
{
  enable = true;
  package = package;
  settings = {
    drawbox = true;
    icons = true;
  };
  keybindings = {
    "D" = ''
      $IFS=''\"$(printf ''\'''\\n''\\t''\')''\"; ${pkgs.trash-cli}/bin/trash-put -- $fx
    '';
    "C" = "push $touch<space>";
    "M" = "push $mkdir<space>";
    "<backspace>" = "set hidden!";
    "<backspace2>" = "set hidden!";
  } // aliasesCd;
  extraConfig = ''
    set previewer ${previewer}
    set cleaner ${cleaner}
  '';
}
