{ pkgs, lib, ... }:

let
  fzf-tab = pkgs.fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "v1.2.0";
    sha256 = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
  };
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    users.jappy = { ... }: {
      home.username = "jappy";
      home.homeDirectory = "/Users/jappy";
      home.stateVersion = "24.11";

      programs.zsh = {
        enable = true;
        initContent = lib.mkMerge [
          # Must run first (order 500) so Oh-My-Zsh finds custom plugins
          (lib.mkOrder 500 ''
            export ZSH_CUSTOM="$HOME/.config/oh-my-zsh-custom"
          '')
          (lib.mkOrder 1000 ''
          # Nix user profile first (home.packages e.g. fzf) then system/homebrew
          export PATH="$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
          export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

          export HISTFILE="$HOME/.zsh_history"
          export HISTSIZE=100000
          export SAVEHIST=100000
          setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS INC_APPEND_HISTORY SHARE_HISTORY

          bindkey '^[[A' history-substring-search-up
          bindkey '^[[B' history-substring-search-down

          export NVM_DIR="$HOME/.nvm"
          [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

          autoload -U add-zsh-hook

          load-nvmrc() {
            local nvmrc_path
            nvmrc_path="$(nvm_find_nvmrc)"

            if [ -n "$nvmrc_path" ]; then
              local nvmrc_node_version
              nvmrc_node_version=$(cat "$nvmrc_path")

              if [ "$(nvm version)" != "$nvmrc_node_version" ]; then
                nvm use "$nvmrc_node_version"
              fi
            fi
          }

          add-zsh-hook chpwd load-nvmrc
          load-nvmrc

          export SSH_AUTH_SOCK=/Users/jappy/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock

          # fzf-tab: modern full-black theme with vibrant accents
          zstyle ':completion:*:descriptions' format '[%d]'
          zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:*' fzf-flags --border=sharp --color=fg:#a0a0a0,bg:#0a0a0a,bg+:#1a1a1a,hl:#00d4ff,hl+:#00ff88,fg+:#ffffff,pointer:#00ff88,info:#5c5c5c,prompt:#ff79c6,spinner:#00d4ff,marker:#00ff88,header:#5c5c5c
          '')
        ];
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [ "git" "fzf-tab" ];
        };
        autosuggestion.enable = true;
        historySubstringSearch.enable = true;
      };

      home.packages = [ pkgs.fzf ];

      # fzf-tab as Oh-My-Zsh custom plugin (clone to ZSH_CUSTOM/plugins/fzf-tab)
      home.file.".config/oh-my-zsh-custom/plugins/fzf-tab".source = fzf-tab;

      programs.starship.enable = true;

      programs.git = {
        enable = true;
        lfs.enable = true;

        signing = {
          signByDefault = true;
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFd6tPmplQulCTVWTN+4lu/RIUMZ045OXszI3EzMJz0";
        };

        settings = {
          user.name = "Jan Jaap";
          user.email = "mail@janjaap.de";
          gpg.format = "ssh";
          gpg.ssh.defaultKeyCommand = "ssh-add -L";
          gpg.ssh.allowedSignersFile = "/Users/jappy/.config/git/allowed_signers";
          init.defaultBranch = "main";
          pull.rebase = true;
          push.autoSetupRemote = true;
          fetch.prune = true;
          rebase.autoStash = true;
        };

      };

      home.file.".config/git/allowed_signers".text = ''
        jappy ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMFd6tPmplQulCTVWTN+4lu/RIUMZ045OXszI3EzMJz0
      '';
    };
  };
}
