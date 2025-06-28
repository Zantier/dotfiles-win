{ config, lib, pkgs, ... }:

{
  networking.hostName = "flippy";
  # From testing, this is the only value on Lenovo Yoga that gives bigger text
  boot.loader.systemd-boot.consoleMode = "2";
  # Fix: steam giving error: glXChooseVisual failed
  hardware.graphics.enable32Bit = true;

  programs.adb.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      # Stops laptop getting hot
      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;
      # CPU scaling reduced by about 10%: lscpu | grep scaling
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  # For dev: vite and websockets
  networking.firewall.allowedTCPPorts = [ 5173 8080 8081 8082 8083 8084 8085 ];
  # UDP 1900: Allow VLC to work as DLNA client (View > Playlist > Universal Plug'n'Play)
  #   But you have to wait a long time compared to disabling firewall
  networking.firewall.allowedUDPPorts = [ 1900 ];
}
