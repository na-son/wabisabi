{ config, inputs, pkgs, lib, ... }:

let
  user = "nason";
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKoLhJuOE878n9BaTFAAmGgmGjztT61HsMRJOU+uKf/t+pJLxUOn3Or2CLMG5EkfKiTZzLFRQ9y1IvHPvmrM5QB5obJP6mJm2xNlL6wmDBKF0qpcXCU5nX3SmFJdbLg5a4FRWLSdMifWK75kvOSBskTYv81W5ncsbRdHK67AciarHYbkPoktoJpJE4EpEPMrPGLS7AaRo1zfbrIfOJJc4LzX2jBzNg1gw0/iPX39KPB/F+N6DzEh8cd43B3dKlqHscHCerpsHVF0EIgFkGm76MrgoJO92qAjeln9ibVSjU9ysS0YP7Z5khyyd19HQFiMQ6Dvp5cmUxndgvKdHooGE/"
  ];

in {
  imports = [
    ../../modules/nixos/disk-config.nix
    ../../modules/shared
    #../../modules/shared/cachix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" "tun" ];
  };

  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "luna";
    usePredictableInterfaceNames = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = {
    nixPath =
      [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      allowed-users = [ "${user}" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

  };

  programs = {
    zsh.enable = true;
  };

  services = {
    dbus.enable = true;
    openssh.enable = true;
    pixiecore = {
      enable = true;
      mode = "boot";
      openFirewall = true;
      kernel = "/etc/nixos/result/kernel";
      initrd = "/etc/nixos/result/initrd";
      #cmdLine = "echo $HOSTNAME";
    };
  };

  systemd = {
    services = {
    };
  };

  hardware = {
    enableAllFirmware = true;
  };

  #virtualisation = {
  #  docker = {
  #    enable = true;
  #    logDriver = "json-file";
  #  };
  #};

  users.users = {
    #${user} = {
    #  isNormalUser = true;
    #  extraGroups = [
    #    "wheel" # Enable ‘sudo’ for the user.
    #    "networkmanager"
    #    "video" # hotplug devices and thunderbolt
    #    "dialout" # TTY access
    #    "docker"
    #  ];
    #  shell = pkgs.zsh;
    #  openssh.authorizedKeys.keys = keys;
    #};

    root = { openssh.authorizedKeys.keys = keys; };
  };

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = "${pkgs.systemd}/bin/reboot";
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
  };

  environment.systemPackages = with pkgs; [ gitAndTools.gitFull inetutils ];
  system.stateVersion = "21.05"; # Don't change this
}
