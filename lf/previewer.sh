w=$2
h=$3
x=$4
y=$5

# Check if current terminal is kitty by checking KITTY_WINDOW_ID env var
if [ -n "$KITTY_WINDOW_ID" ]; then
  image() {
    kitten icat --silent --transfer-mode file --stdin no --place "${w}x${h}@${x}x${y}" "$1" < /dev/null > /dev/tty
  }
else
  image() {
    echo "IMAGE PREVIEW NOT SUPPORTED"
  }
fi


CACHE_DIR="${HOME}/.cache/lf"
mkdir -p "${CACHE_DIR}"
CACHE="${CACHE_DIR}/thumbnail.$(stat --printf '%n\0%i\0%F\0%s\0%W\0%Y' -- "$(readlink -f "$1")" | sha256sum | awk '{print $1}'))"

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
      [ ! -f "${CACHE}.jpg" ] && \
        pdftoppm -jpeg -f 1 -singlefile "$1" "${CACHE}"
      image "${CACHE}.jpg"
      ;;
  *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
      [ ! -f "${CACHE}.jpg" ] && \
        ffmpegthumbnailer -i "$1" -o "${CACHE}.jpg" -s 0 -q 5
      image "${CACHE}.jpg"
      ;;
  *.bmp|*.jpg|*.jpeg|*.png|*.xpm|*.webp|*.tiff|*.gif|*.jfif|*.ico|*.svg) image "$1" ;;
  *) bat --terminal-width "$(($2-2))" --wrap character --pager never --style numbers "$1" ;;
esac
exit 1
