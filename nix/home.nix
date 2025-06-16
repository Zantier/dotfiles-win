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
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  home.packages = with pkgs; [
    # Needed occasionally by tree-sitter in neovim
    gcc
    git
    # Since upgrading nixos to 25.05beta. Fix Chrome being double size.
    (google-chrome.override {
      commandLineArgs = "--force-device-scale-factor=2";
    })
    htop
    (imagemagick.override {
      ghostscriptSupport = true;
    })
    kitty
    # Nix language server
    nil
    slack
    spotify
    tree-sitter
    vlc
    wget
    xclip
    xidlehook
    xorg.xkbcomp
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
  programs.gpg = {
    enable = true;
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

  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [ xdotool coreutils xorg.xprop ];
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

  xdg.desktopEntries = {
    shh = {
      name = "shh";
      exec = "shutdown 0";
      comment = "shutdown 0";
    };
  };

  xfconf.settings = {
    keyboards = {
      "Default/KeyRepeat/Delay" = 200;
      "Default/KeyRepeat/Rate" = 30;
    };
    xfce4-keyboard-shortcuts = {
      "commands/custom/<Super>space" = "xfce4-appfinder";
      "xfwm4/custom/<Super>KP_Left" = null; # tile_left_key;
      "xfwm4/custom/<Super>KP_Right" = null; # tile_right_key
      "xfwm4/custom/<Alt>F10" = null; # maximize_window_key;
      "xfwm4/custom/<Super>Left" = "tile_left_key";
      "xfwm4/custom/<Super>Right" = "tile_right_key";
      "xfwm4/custom/<Super>Up" = "maximize_window_key";
    };
    xfce4-panel = {
      "panels" = [ 1 ];
      "panels/panel-1/enable-struts" = null;
      "panels/panel-1/icon-size" = null;
      "panels/panel-1/length" = 100;
      "panels/panel-1/length-adjust" = null;
      "panels/panel-1/mode" = null;
      "panels/panel-1/nrows" = null;
      "panels/panel-1/plugin-ids" = [ 1 2 3 4 5 6 7 8 9 10 11 ];
      "panels/panel-1/position" = "p=6;x=0;y=0";
      "panels/panel-1/position-locked" = true;
      "panels/panel-1/size" = 26;
      "plugins/plugin-1" = "applicationsmenu";
      "plugins/plugin-2" = "tasklist";
      "plugins/plugin-2/grouping" = 1;
      "plugins/plugin-2/show-labels" = false;
      "plugins/plugin-3" = "separator";
      "plugins/plugin-3/expand" = true;
      "plugins/plugin-3/style" = 0;
      "plugins/plugin-4" = "pager";
      "plugins/plugin-5" = "separator";
      "plugins/plugin-5/style" = 0;
      "plugins/plugin-6" = "systray";
      "plugins/plugin-6/square-icons" = true;
      "plugins/plugin-7" = "pulseaudio";
      "plugins/plugin-8" = "power-manager-plugin";
      "plugins/plugin-9" = "clock";
      "plugins/plugin-10" = "separator";
      "plugins/plugin-10/style" = 0;
      "plugins/plugin-11" = "actions";
    };
    xfce4-power-manager = {
      "xfce4-power-manager/brightness-step-count" = 7;
      "xfce4-power-manager/brightness-exponential" = true;
      # 1 = Suspend
      "xfce4-power-manager/lid-action-on-battery" = 1;
      "xfce4-power-manager/lid-action-on-ac" = 1;
      # Put to sleep after
      "xfce4-power-manager/dpms-on-battery-sleep" = 11;
      "xfce4-power-manager/dpms-on-ac-sleep" = 11;
      # Switch off after
      "xfce4-power-manager/dpms-on-battery-off" = 12;
      "xfce4-power-manager/dpms-on-ac-off" = 12;
      # On inactivity reduce to (%)
      "xfce4-power-manager/brightness-level-on-battery" = 1;
      "xfce4-power-manager/brightness-level-on-ac" = 1;
      # Reduce after (s)
      "xfce4-power-manager/brightness-on-battery" = 600;
      "xfce4-power-manager/brightness-on-ac" = 600;
    };
    xsettings = {
      "Gtk/CursorThemeName" = "Adwaita";
      "Gtk/CursorThemeSize" = 41;
      "Net/ThemeName" = "Adwaita-dark";
      "Xft/DPI" = 192;
    };
  };
}
