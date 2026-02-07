{ pkgs, ... }:

let
  fzf-tab = pkgs.fetchFromGitHub {
    owner = "Aloxaf";
    repo = "fzf-tab";
    rev = "v1.2.0";
    sha256 = "0000000000000000000000000000000000000000000000000000";
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
        oh-my-zsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [ "git" ];
        };
        autosuggestion.enable = true;
        historySubstringSearch.enable = true;
        initContent = ''
          export PATH="/run/current-system/sw/bin:/run/current-system/sw/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
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
        '';
      };

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
