{ config, lib, ... }:

{
  system.activationScripts.postActivation.text = lib.mkAfter ''
    primary_user="${config.system.primaryUser}"
    dockutil="/opt/homebrew/bin/dockutil"
    if [ ! -x "$dockutil" ]; then
      exit 0
    fi

    run_dockutil() {
      /bin/launchctl asuser "$(/usr/bin/id -u -- "$primary_user")" \
        /usr/bin/sudo --user="$primary_user" --set-home -- \
        "$dockutil" "$@"
    }

    run_dockutil --remove all --no-restart

    add_if_exists() {
      path="$1"
      if [ -e "$path" ]; then
        run_dockutil --add "$path" --no-restart
      fi
    }

    add_if_exists "/System/Applications/Finder.app"
    add_if_exists "/Applications/Brave Browser.app"
    add_if_exists "/Applications/PWAs/Crunchyroll.app"
    add_if_exists "/System/Applications/Mail.app"
    add_if_exists "/System/Applications/Calendar.app"
    add_if_exists "/System/Applications/Reminders.app"
    add_if_exists "/Applications/PWAs/GitHub.app"
    add_if_exists "/Applications/Linear.app"
    add_if_exists "/Applications/Cursor.app"
    add_if_exists "/Applications/iTerm.app"

    add_if_exists "/Applications/WhatsApp.app"
    add_if_exists "/System/Applications/Messages.app"
    add_if_exists "/Applications/Discord.app"
    add_if_exists "/Applications/Signal.app"
    add_if_exists "/Applications/PWAs/SimplyPrint.app"
    add_if_exists "/Applications/Bitwarden.app"
    run_dockutil --add "/Users/$primary_user/Downloads" --view grid --display stack --sort dateadded --no-restart
    /usr/bin/killall Dock
  '';
}
