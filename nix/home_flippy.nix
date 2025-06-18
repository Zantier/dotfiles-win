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
    export ANDROID_HOME="/z/android-sdk"
    export PNPM_HOME="/z/pnpm"
    export PATH="$PNPM_HOME:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
  '';
}
