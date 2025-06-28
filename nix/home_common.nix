{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zan";
  home.homeDirectory = "/home/zan";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  home.packages = with pkgs; [
    # Needed occasionally by tree-sitter in neovim
    gcc
    git
    htop
    (imagemagick.override {
      ghostscriptSupport = true;
    })
    # Nix language server
    nil
    slack
    spotify
    tree-sitter
    unzip
    wget
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    # 47 light gray, 102 light green, 103 light yellow, 104 light blue, 105 light magenta, 106 light cyan, 107 white
    prompt_color="105"
    alias ggmail='git init;git config user.name "Dave Phillips";git config user.email zantier.tasa@gmail.com'
    alias gdot='git init;git config user.name "Dave Phillips";git config user.email david@dottxt.co'
    source ~/.my.sh
    export NNN_FIFO=/tmp/nnn.fifo
    export NNN_TMPFILE=/tmp/nnn.lastd
    alias z='nnn-cd /z'
    py() {
      nix-shell -p python311 --run "python $@"
    }
  '';
  programs.bash.profileExtra = ''
    export PATH="$HOME/.local/bin:$HOME/.npm/bin:$PATH"
  '';
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.firefox.enable = true;
  programs.gpg = {
    enable = true;
  };
  programs.kitty = {
    enable = true;
    settings = {
      allow_remote_control = true;
      enable_audio_bell = false;
      listen_on = "unix:@kitty";
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };
  programs.nnn = {
    enable = true;
    extraPackages = [
      pkgs.bat
      pkgs.mediainfo
      pkgs.poppler_utils
    ];
    plugins = {
      src = (
        pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v5.1";
          sha256 = "sha256-+2lFFBtaqRPBkEspCFtKl9fllbSR5MBB+4ks3Xh7vp4=";
        }
      ) + "/plugins";
      mappings = {
        p = "preview-tui";
      };
    };
  };
  programs.tmux = {
    enable = true;
    historyLimit = 50000;
    mouse = true;
    prefix = "C-a";
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  xdg.desktopEntries = {
    shh = {
      name = "shh";
      exec = "shutdown 0";
      comment = "shutdown 0";
    };
  };
}
