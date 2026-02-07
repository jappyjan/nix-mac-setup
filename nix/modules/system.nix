{ config, lib, pkgs, ... }:

{
  # Required by nix-darwin for stateful defaults
  system.stateVersion = 5;

  # Let nix-darwin manage itself
  nix.enable = true;

  system.primaryUser = "jappy";

  # Enable flakes + nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow Touch ID for sudo authentication in CLI
  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPath = [
    "/run/current-system/sw/bin"
    "/run/current-system/sw/sbin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];

  # Your user account
  users.users.jappy = {
    home = "/Users/jappy";
    shell = pkgs.zsh;
  };

  system.activationScripts.javaSymlink.text = lib.mkAfter ''
    mkdir -p /Library/Java/JavaVirtualMachines
    ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
  '';
}
