{ ... }:
{
  imports = [
    ./modules/system.nix
    ./modules/packages.nix
    ./modules/homebrew.nix
    ./modules/defaults.nix
    ./modules/launchd.nix
    ./modules/dock.nix
    ./modules/pwa.nix
    ./modules/home-manager.nix
  ];
}