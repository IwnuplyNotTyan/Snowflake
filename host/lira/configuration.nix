{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./module/ssh.nix
      ./module/internet.nix
    ];

  fileSystems."/mnt/sda" = {
  	device = "/dev/disk/by-uuid/e1d4f265-ea6d-4864-aff5-943cb3bd3b40";
  	fsType = "ext4";
  	options = [
  	"nofail"
  	];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Kyiv";
  i18n.defaultLocale = "en_US.UTF-8";
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

  users.users.q = {
    isNormalUser = true;
    description = "lira";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim

    # Git
    git
    github-cli
  ];

  virtualisation.docker = {
	enable = true;
  };

  system.stateVersion = "24.05";
}
