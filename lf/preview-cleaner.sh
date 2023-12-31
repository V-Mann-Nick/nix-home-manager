if [ -n "$KITTY_WINDOW_ID" ]; then
  kitten icat --clear --silent --transfer-mode file --stdin no < /dev/null > /dev/tty
fi
