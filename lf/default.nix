{ pkgs, lib, aliases, ... }:
let 
  cleanerPackage = pkgs.writeScriptBin "cleaner.sh" ''
    #!/bin/sh
    kitten icat --clear --silent --transfer-mode file --stdin no < /dev/null > /dev/tty
  '';
  cleaner = "${cleanerPackage}/bin/cleaner.sh";
  previewerPackage = pkgs.writeScriptBin "pv.sh" ''
    #!/usr/bin/env bash
    w=$2
    h=$3
    x=$4
    y=$5

    image() {
        kitten icat --silent --transfer-mode file --stdin no --place "''${w}x''${h}@''${x}x''${y}" "$1" < /dev/null > /dev/tty
    }

    CACHE_DIR="$HOME/.cache/lf"
    mkdir -p "$CACHE_DIR"
    CACHE="$CACHE_DIR/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}'))"

    case "$(printf "%s\n" "$(readlink -f "$1")" | awk '{print tolower($0)}')" in
      *.tgz|*.tar.gz) tar tzf "$1" ;;
      *.tar.bz2|*.tbz2) tar tjf "$1" ;;
      *.tar.txz|*.txz) xz --list "$1" ;;
      *.tar) tar tf "$1" ;;
      *.zip|*.jar|*.war|*.ear|*.oxt) unzip -l "$1" ;;
      *.rar) unrar l "$1" ;;
      *.md) glow "$1";;
      *.iso) iso-info --no-header -l "$1" ;;
      *.odt|*.ods|*.odp|*.sxw) odt2txt "$1" ;;
      *.doc) catdoc "$1" ;;
      *.docx) catdocx "$1" ;;
      *.pdf)
          [ ! -f "''${CACHE}.jpg" ] && \
            pdftoppm -jpeg -f 1 -singlefile "$1" "$CACHE"
          image "''${CACHE}.jpg"
          ;;
      *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
          [ ! -f "''${CACHE}.jpg" ] && \
            ffmpegthumbnailer -i "$1" -o "''${CACHE}.jpg" -s 0 -q 5
          image "''${CACHE}.jpg"
          ;;
      *.bmp|*.jpg|*.jpeg|*.png|*.xpm|*.webp|*.tiff|*.gif|*.jfif|*.ico|*.svg) image "$1" ;;
      *) bat --terminal-width "$(($2-2))" --wrap character --pager never --style numbers "$1" ;;
    esac
    exit 1
  '';
  previewer = "${previewerPackage}/bin/pv.sh";
  lfPackage = pkgs.lf;
  lf = "${lfPackage}/bin/lf";
  icons = {
    "ln" = " ";
    "or" = " ";
    "tw" = "t ";
    "ow" = " ";
    "st" = "t ";
    "di" = " ";
    "pi" = "p ";
    "so" = "s ";
    "bd" = "b ";
    "cd" = "c ";
    "su" = "u ";
    "sg" = "g ";
    "ex" = " ";
    "fi" = " ";
    "*.styl" = " ";
    "*.sass" = " ";
    "*.scss" = " ";
    "*.htm" = " ";
    "*.html" = " ";
    "*.slim" = " ";
    "*.haml" = " ";
    "*.ejs" = " ";
    "*.css" = " ";
    "*.less" = " ";
    "*.md" = " ";
    "*.mdx" = " ";
    "*.markdown" = " ";
    "*.rmd" = " ";
    "*.json" = " ";
    "*.webmanifest" = " ";
    "*.js" = " ";
    "*.mjs" = " ";
    "*.cjs" = " ";
    "*.jsx" = " ";
    "*.rb" = " ";
    "*.gemspec" = " ";
    "*.rake" = " ";
    "*.php" = " ";
    "*.py" = " ";
    "*.pyc" = " ";
    "*.pyo" = " ";
    "*.pyd" = " ";
    "*.coffee" = " ";
    "*.mustache" = " ";
    "*.hbs" = " ";
    "*.conf" = " ";
    "*.ini" = " ";
    "*.yml" = " ";
    "*.yaml" = " ";
    "*.toml" = " ";
    "*.bat" = " ";
    "*.mk" = " ";
    "*.twig" = " ";
    "*.cpp" = " ";
    "*.c++" = " ";
    "*.cxx" = " ";
    "*.cc" = " ";
    "*.cp" = " ";
    "*.c" = " ";
    "*.cs" = "󰌛 ";
    "*.h" = " ";
    "*.hh" = " ";
    "*.hpp" = " ";
    "*.hxx" = " ";
    "*.hs" = " ";
    "*.lhs" = " ";
    "*.nix" = " ";
    "*.lua" = " ";
    "*.java" = " ";
    "*.sh" = " ";
    "*.fish" = " ";
    "*.bash" = " ";
    "*.zsh" = " ";
    "*.ksh" = " ";
    "*.csh" = " ";
    "*.awk" = " ";
    "*.ps1" = " ";
    "*.ml" = "λ";
    "*.mli" = "λ";
    "*.diff" = " ";
    "*.db" = " ";
    "*.sql" = " ";
    "*.dump" = " ";
    "*.clj" = " ";
    "*.cljc" = " ";
    "*.cljs" = " ";
    "*.edn" = " ";
    "*.scala" = "";
    "*.go" = " ";
    "*.dart" = " ";
    "*.xul" = " ";
    "*.sln" = " ";
    "*.suo" = " ";
    "*.pl" = " ";
    "*.pm" = " ";
    "*.t" = " ";
    "*.rss" = " ";
    "'*.f#'" = " ";
    "*.fsscript" = " ";
    "*.fsx" = " ";
    "*.fs" = " ";
    "*.fsi" = " ";
    "*.rs" = " ";
    "*.rlib" = " ";
    "*.d" = " ";
    "*.erl" = " ";
    "*.hrl" = " ";
    "*.ex" = "";
    "*.exs" = "";
    "*.eex" = "";
    "*.leex" = "";
    "*.heex" = "";
    "*.vim" = " ";
    "*.ai" = " ";
    "*.psd" = " ";
    "*.psb" = " ";
    "*.ts" = " ";
    "*.tsx" = " ";
    "*.jl" = " ";
    "*.pp" = " ";
    "*.vue" = "󰡄 ";
    "*.elm" = " ";
    "*.swift" = " ";
    "*.xcplayground" = " ";
    "*.tex" = "󰙩 ";
    "*.r" = "󰟔 ";
    "*.rproj" = "󰗆 ";
    "*.sol" = "󰞻";
    "*.pem" = "󰌋 ";
    "*gruntfile.coffee" = " ";
    "*gruntfile.js" = " ";
    "*gruntfile.ls" = " ";
    "*gulpfile.coffee" = "";
    "*gulpfile.js" = "";
    "*gulpfile.ls" = "";
    "*mix.lock" = "";
    "*dropbox" = " ";
    "*.ds_store" = " ";
    "*.gitconfig" = " ";
    "*.gitignore" = " ";
    "*.gitattributes" = " ";
    "*.gitlab-ci.yml" = " ";
    "*.bashrc" = " ";
    "*.zshrc" = " ";
    "*.zshenv" = " ";
    "*.zprofile" = " ";
    "*.vimrc" = " ";
    "*.gvimrc" = " ";
    "*_vimrc" = " ";
    "*_gvimrc" = " ";
    "*.bashprofile" = " ";
    "*favicon.ico" = " ";
    "*license" = " ";
    "*node_modules" = " ";
    "*react.jsx" = " ";
    "*procfile" = "";
    "*dockerfile" = " ";
    "*docker-compose.yml" = " ";
    "*rakefile" = " ";
    "*config.ru" = " ";
    "*gemfile" = " ";
    "*makefile" = " ";
    "*cmakelists.txt" = " ";
    "*robots.txt" = "󰚩 ";
    "*Gruntfile.coffee" = " ";
    "*Gruntfile.js" = " ";
    "*Gruntfile.ls" = " ";
    "*Gulpfile.coffee" = "";
    "*Gulpfile.js" = "";
    "*Gulpfile.ls" = "";
    "*Dropbox" = " ";
    "*.DS_Store" = " ";
    "*LICENSE" = "";
    "*React.jsx" = " ";
    "*Procfile" = "";
    "*Dockerfile" = " ";
    "*Docker-compose.yml" = " ";
    "*Rakefile" = " ";
    "*Gemfile" = " ";
    "*Makefile" = " ";
    "*CMakeLists.txt" = " ";
    ".*jquery.*\.js$" = " ";
    ".*angular.*\.js$" = " ";
    ".*backbone.*\.js$" = " ";
    ".*require.*\.js$" = " ";
    ".*materialize.*\.js$" = " ";
    ".*materialize.*\.css$" = " ";
    ".*mootools.*\.js$" = "";
    ".*vimrc.*" = " ";
    "Vagrantfile$" = " ";
    "*jquery.min.js" = " ";
    "*angular.min.js" = " ";
    "*backbone.min.js" = " ";
    "*require.min.js" = " ";
    "*materialize.min.js" = " ";
    "*materialize.min.css" = " ";
    "*mootools.min.js" = "";
    "*vimrc" = " ";
    "Vagrantfile" = " ";
    "*.tar" = " ";
    "*.tgz" = " ";
    "*.arc" = " ";
    "*.arj" = " ";
    "*.taz" = " ";
    "*.lha" = " ";
    "*.lz4" = " ";
    "*.lzh" = " ";
    "*.lzma" = " ";
    "*.tlz" = " ";
    "*.txz" = " ";
    "*.tzo" = " ";
    "*.t7z" = " ";
    "*.zip" = " ";
    "*.z" = " ";
    "*.dz" = " ";
    "*.gz" = " ";
    "*.lrz" = " ";
    "*.lz" = " ";
    "*.lzo" = " ";
    "*.xz" = " ";
    "*.zst" = " ";
    "*.tzst" = " ";
    "*.bz2" = " ";
    "*.bz" = " ";
    "*.tbz" = " ";
    "*.tbz2" = " ";
    "*.tz" = " ";
    "*.deb" = " ";
    "*.rpm" = " ";
    "*.jar" = " ";
    "*.war" = " ";
    "*.ear" = " ";
    "*.sar" = " ";
    "*.rar" = " ";
    "*.alz" = " ";
    "*.ace" = " ";
    "*.zoo" = " ";
    "*.cpio" = " ";
    "*.7z" = " ";
    "*.rz" = " ";
    "*.cab" = " ";
    "*.wim" = " ";
    "*.swm" = " ";
    "*.dwm" = " ";
    "*.esd" = " ";
    "*.jpg" = " ";
    "*.jpeg" = " ";
    "*.mjpg" = " ";
    "*.mjpeg" = " ";
    "*.gif" = " ";
    "*.bmp" = " ";
    "*.pbm" = " ";
    "*.pgm" = " ";
    "*.ppm" = " ";
    "*.tga" = " ";
    "*.xbm" = " ";
    "*.xpm" = " ";
    "*.tif" = " ";
    "*.tiff" = " ";
    "*.png" = " ";
    "*.svg" = " ";
    "*.svgz" = " ";
    "*.mng" = " ";
    "*.pcx" = " ";
    "*.mov" = " ";
    "*.mpg" = " ";
    "*.mpeg" = " ";
    "*.m2v" = " ";
    "*.mkv" = " ";
    "*.webm" = " ";
    "*.ogm" = " ";
    "*.mp4" = " ";
    "*.m4v" = " ";
    "*.mp4v" = " ";
    "*.vob" = " ";
    "*.qt" = " ";
    "*.nuv" = " ";
    "*.wmv" = " ";
    "*.asf" = " ";
    "*.rm" = " ";
    "*.rmvb" = " ";
    "*.flc" = " ";
    "*.avi" = " ";
    "*.fli" = " ";
    "*.flv" = " ";
    "*.gl" = " ";
    "*.dl" = " ";
    "*.xcf" = " ";
    "*.xwd" = " ";
    "*.yuv" = " ";
    "*.cgm" = " ";
    "*.emf" = " ";
    "*.ogv" = " ";
    "*.ogx" = " ";
    "*.aac" = " ";
    "*.au" = " ";
    "*.flac" = " ";
    "*.m4a" = " ";
    "*.mid" = " ";
    "*.midi" = " ";
    "*.mka" = " ";
    "*.mp3" = " ";
    "*.mpc" = " ";
    "*.ogg" = " ";
    "*.ra" = " ";
    "*.wav" = " ";
    "*.oga" = " ";
    "*.opus" = " ";
    "*.spx" = " ";
    "*.xspf" = " ";
    "*.pdf" = " ";
    "*.tf" = " ";
  };
  setToEnvVar = set: lib.concatStringsSep ":" (lib.attrValues (lib.mapAttrs (ext: icon: "${ext}=${icon}") set));
  iconEnvVar = setToEnvVar icons;
  aliasesCd = builtins.listToAttrs (lib.mapAttrsToList (alias: path: { name = "g${alias}"; value = "cd ${path}"; }) aliases);
  package = pkgs.writeScriptBin "lf" ''
    #!/bin/sh
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
    "D" = "$trash-put -- \"$fx\"";
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
