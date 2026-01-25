{ pkgs, ... }:

{
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.12"
  ];

  # Basic system packages
  environment.systemPackages = with pkgs; [
    python27
    python3
  ];
}
