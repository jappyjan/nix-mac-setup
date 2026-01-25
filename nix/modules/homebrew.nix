{ ... }:

{
  homebrew = {
    enable = true;

    brews = [
      "nvm"
      "mas"
      "supabase"
      "dockutil"
    ];

    caskArgs = {
      appdir = "/Applications";
    };

    casks = [
      "brave-browser"
      "linear-linear"
      "cursor"
      "iterm2"
      "discord"
      "signal"
      "raycast"
      "docker-desktop"
      "meetingbar"
      "darkmodebuddy"
      "orcaslicer"
      "google-drive"
      "nvidia-geforce-now"
      "font-fira-code"
    ];

    masApps = {
      Bitwarden = 1352778147;
      Whatsapp = 310633997;
      Telegram = 747648890;
      HomeAssistant = 1099568401;
      WireGuard = 1451685025;
      LanScan = 472226235;
      MQTTExplorer = 1455214828;
    };
  };
}
