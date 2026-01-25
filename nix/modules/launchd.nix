{ ... }:

{
  launchd.user.agents = {
    "set-wallpaper" = {
      serviceConfig = {
        ProgramArguments = [
          "/usr/bin/osascript"
          "-e"
          "tell application \"System Events\" to set picture of every desktop to \"/Users/jappy/code/jappyjan/nix-mac-setup/assets/wallpapers/japan.heic\""
        ];
        RunAtLoad = true;
      };
    };

    "google-drive" = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/open" "-a" "Google Drive" ];
        RunAtLoad = true;
      };
    };

    "meetingbar" = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/open" "-a" "MeetingBar" ];
        RunAtLoad = true;
      };
    };

    "homeassistant" = {
      serviceConfig = {
        ProgramArguments = [ "/usr/bin/open" "-a" "Home Assistant" ];
        RunAtLoad = true;
      };
    };
  };
}
