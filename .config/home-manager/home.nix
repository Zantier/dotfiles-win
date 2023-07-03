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
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  home.packages = with pkgs; [
    clang
    git
    google-chrome
    htop
    kitty
    krita
    neovim
    nodejs
    nvtop-amd
    ranger
    simplenote
    tmux
    tree-sitter
    vscode
    wget
    xclip
    xorg.xkbcomp
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

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/zan/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bash.enable = true;
  programs.bash.initExtra = ''
    # 47 light gray, 102 light green, 103 light yellow, 104 light blue, 105 light magenta, 106 light cyan, 107 white
    prompt_color="105"
    alias ggmail='git init;git config user.name "David Phillips";git config user.email zantier.tasa@gmail.com'
    source ~/.my.sh

    export CC=clang++
    export EDITOR=nvim
    alias vim=$EDITOR
    alias home='cd /z'

    eval "$(direnv hook bash)"
  '';
  programs.bash.profileExtra = ''
    export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
  '';

  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [ coreutils xdotool ];
    settings = {
      swipe = {
        "3" = {
          left = {
            command = "xdotool set_desktop --relative 1";
          };
          right = {
            command = "xdotool set_desktop --relative -- -1";
          };
        };
      };
      #pinch = {
      #  "in" = {
      #    command = "xdotool keydown ctrl click 4 keyup ctrl";
      #  };
      #  out = {
      #    command = "xdotool keydown ctrl click 5 keyup ctrl";
      #  };
      #};
    };
  };
}
