# nix-mac-setup

Central storage for my macOS Nix configuration.

## Setup
```bash
curl -fsSL https://raw.githubusercontent.com/jappyjan/nix-mac-setup/main/scripts/bootstrap.sh | bash
```

## Usage

### 1) First-time setup
```bash
./scripts/setup.sh
```

### 2) Apply configuration
```bash
./scripts/apply.sh
```

## Structure
- `flake.nix`: entry point for the Nix flake and host configs
- `nix/darwin-configuration.nix`: main nix-darwin config
- `scripts/setup.sh`: bootstrap Nix on a fresh Mac
- `scripts/apply.sh`: apply config on the current Mac

## Adding another Mac
1) Create a host file at `nix/hosts/<LocalHostName>.nix`
2) Add it to `flake.nix` under `darwinConfigurations."<LocalHostName>"`
   - This is just the configuration name. It does not change your Mac's hostname.
3) Run `./scripts/apply.sh` on that Mac
4) If you want nix-darwin to enforce the hostname, add
   `networking.hostName = "<name>";` inside the host file

## Notes
- `./scripts/apply.sh` must be run with `sudo`
- For new Macs, create a host file and add it to `flake.nix` before applying

## Post-install manual steps
- Authenticate in installed apps (Bitwarden, Google Drive, Discord, Signal, etc.)
- For PWAs, `pwa-github` launches the GitHub PWA in Brave