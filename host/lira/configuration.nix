
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, outputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "nixos";
  
  # Locale and timezone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Kyiv";
  i18n.extraLocaleSettings = {
  LC_ADDRESS = "uk_UA.UTF-8";
  LC_IDENTIFICATION = "uk_UA.UTF-8";
  LC_MEASUREMENT = "uk_UA.UTF-8";
  LC_MONETARY = "uk_UA.UTF-8";
  LC_NAME = "uk_UA.UTF-8";
  LC_NUMERIC = "uk_UA.UTF-8";
  LC_PAPER = "uk_UA.UTF-8";
  LC_TELEPHONE = "uk_UA.UTF-8";
  LC_TIME = "uk_UA.UTF-8";
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  
  # User
  users.users.q = {
    isNormalUser = true;
    description = "iwnuplylo";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      firefox
     ];
  };

  # Network
  networking.networkmanager.enable = true;
  # OpenSSH
  services.openssh.enable = true;
  
  # PKGS
  environment.systemPackages = with pkgs; [
  neovim
  git
  tmux
  doas
  ];

  # Doas Enable & Config
  security = {
    doas = {
    enable = true;
  extraConfig = ''
  permit persist keepenv :wheel
  '';
  };
  };

  # Sudo Disable
  security.sudo.enable = false; # Sudo Disable

  # System
  system.stateVersion = "23.05";
}
