{
  description = "Nix macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      system = "aarch64-darwin"; # use "x86_64-darwin" if Intel
    in
    {
      darwinConfigurations."MacBook-Air-von-Jan" = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./nix/darwin-configuration.nix
          ./nix/hosts/MacBook-Air-von-Jan.nix
          home-manager.darwinModules.home-manager
        ];
      };
    };
}