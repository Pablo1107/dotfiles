self: pkgs:

with pkgs;

{
  wl-screenshot = writeShellScriptBin "wl-screenshot" ''
    # Screenshot helper for sway based on Witalij Berdinskich script

    if [ -z $WAYLAND_DISPLAY ]; then
      (>&2 echo Wayland is not running)
      exit 1
    fi

    # parse arguments
    PARAMS=""

    while (( "$#" )); do
      case "$1" in
        --ocr)
          OCR=1
          shift
          ;;
        *) # preserve positional arguments
          PARAMS="$PARAMS $1"
          shift
          ;;
      esac
    done

    # set positional arguments in their proper place
    eval set -- "$PARAMS"

    if [ -z $SWAYSHOT_SCREENSHOTS ]; then
      SWAYSHOT_SCREENSHOTS=$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)
    fi

    SCREENSHOT_TIMESTAMP=$(date "+$\{SWAYSHOT_DATEFMT:-%F_%H-%M-%S_%N}")
    SCREENSHOT_FULLNAME="$SWAYSHOT_SCREENSHOTS"/screenshot_$\{SCREENSHOT_TIMESTAMP}.png

    make_screenshot() {
      case "$1" in
        -h|--help)
          echo "Usage: $0 [display|window|region|qr]"
          return 0
          ;;
        qr|region)
          ${grim}/bin/grim -g "$(${slurp}/bin/slurp -b '#25252DAF' -c '#25252D' -s '#00000000' -w 3 -d)" "$2"
          ;;
        window)
          ${grim}/bin/grim -g "$(${sway}/bin/swaymsg -t get_tree | ${jq}/bin/jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | ${slurp}/bin/slurp -b '#25252DAF' -B '#25252DAF' -c '#25252D')" "$2"
          ;;
        *)
          ${grim}/bin/grim -o "$(${sway}/bin/swaymsg --type get_outputs --raw | ${jq}/bin/jq --raw-output '.[] | select(.focused) | .name')" "$2"
          ;;
      esac
    }

    copy_to_clipboard() {
      ${wl-clipboard}/bin/wl-copy < "$SCREENSHOT_FULLNAME"
      # if type ${wl-clipboard}/bin/wl-copy >/dev/null  2>&1; then
      #   ${wl-clipboard}/bin/wl-copy < "$SCREENSHOT_FULLNAME"
      # elif type xsel >/dev/null  2>&1; then
      #   printf "%s" "$1" | xsel --clipboard
      # elif type xclip &>/dev/null; then
      #   printf "%s" "$1" | xclip -selection clipboard
      # else
      #   echo "$1"
      # fi
    }

    show_message() {
      if type ${libnotify}/bin/notify-send >/dev/null  2>&1; then
        ${libnotify}/bin/notify-send --expire-time=3000 --category=screenshot --icon="$2" "$3" "$1"
      fi
    }

    upload_screenshot() {
      if [ -f "$1" ]; then
        if type ${curl}/bin/curl >/dev/null  2>&1; then
          ${curl}/bin/curl -s -F "file=@\"$1\";filename=.png" 'https://x0.at'
        fi
      fi
    }

    ocr() {
      ${tesseract}/bin/tesseract $SCREENSHOT_FULLNAME stdout --dpi 270 | ${wl-clipboard}/bin/wl-copy
    }

    make_screenshot "$1" "$SCREENSHOT_FULLNAME"

    if [ ! -f "$SCREENSHOT_FULLNAME" ]; then
      return 1;
    fi

    if [ ! -z "$OCR" ]; then
      ocr
      show_message "OCR scan\n(copied to clipboard)" "$SCREENSHOT_FULLNAME" "Screenshot image"
      rm "$SCREENSHOT_FULLNAME"
      return 0
    fi

    SCANRESULT=$(${zbar}/bin/zbarimg --quiet --raw "$SCREENSHOT_FULLNAME" | tr -d '\n')

    if [ ! -z "$SCANRESULT" ]; then
      ${wl-clipboard}/bin/wl-copy "$SCANRESULT"
      show_message "$SCANRESULT\n(copied to clipboard)" "$SCREENSHOT_FULLNAME" "QR image"
      rm "$SCREENSHOT_FULLNAME"
      return 0
    fi

    copy_to_clipboard "$SCREENSHOT_FULLNAME"
    show_message "$SCREENSHOT_FULLNAME" document-save "Screenshot path"
    show_message "Screenshot was copied to clipboard.\\nFeel free to paste it." "$SCREENSHOT_FULLNAME" "Screenshot image"
  '';
}
