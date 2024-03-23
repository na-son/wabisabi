{ pkgs }:

with pkgs;
let shared-packages = import ../shared/packages.nix { inherit pkgs; };
in shared-packages ++ [

  # App and package management
  #gnumake
  #cmake

  # Core unix tools
  unixtools.ifconfig
  unixtools.netstat
  pciutils
  inotify-tools
  #libnotify
  #greetd.tuigreet

]
