{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    android-studio
    blender
    bun
    discord
    # For autocomplete in vscode for unity project
    dotnet-sdk
    fceux
    gimp
    krita
    musescore
    nodejs
    # Use this, because simplenote package is no longer maintained
    nvpy
    nvtopPackages.amd
    reaper
    snes9x
    steam
    texliveFull
    texmacs
    unityhub
  ];

  programs.bash.initExtra = ''
    # 47 light gray, 102 light green, 103 light yellow, 104 light blue, 105 light magenta, 106 light cyan, 107 white
    prompt_color="105"
    alias ggmail='git init;git config user.name "Dave Phillips";git config user.email zantier.tasa@gmail.com'
    alias gdot='git init;git config user.name "Dave Phillips";git config user.email david@dottxt.co'
    source ~/.my.sh
    export ANDROID_HOME="/z/android-sdk"
    export PNPM_HOME="/z/pnpm"
    export PATH="$PNPM_HOME:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
    export NNN_FIFO=/tmp/nnn.fifo
    export NNN_TMPFILE=/tmp/nnn.lastd
    alias z='nnn-cd /z'
    py() {
      nix-shell -p python311 --run "python $@"
    }
  '';
}
