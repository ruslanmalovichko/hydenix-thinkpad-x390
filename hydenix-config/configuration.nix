{
  inputs,
  ...
}:
let
  # Package declaration
  # ---------------------

  pkgs = import inputs.hydenix.inputs.hydenix-nixpkgs {
    inherit (inputs.hydenix.lib) system;
    config.allowUnfree = true;
    overlays = [
      inputs.hydenix.lib.overlays
      (final: prev: {
        userPkgs = import inputs.nixpkgs {
          config.allowUnfree = true;
        };
      })
    ];
  };
in
{

  # Set pkgs for hydenix globally, any file that imports pkgs will use this
  nixpkgs.pkgs = pkgs;

  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    inputs.hydenix.lib.nixOsModules
    ./modules/system

    # === GPU-specific configurations ===

    /*
      For drivers, we are leveraging nixos-hardware
      Most common drivers are below, but you can see more options here: https://github.com/NixOS/nixos-hardware
    */

    #! EDIT THIS SECTION
    # For NVIDIA setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-nvidia

    # For AMD setups
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-gpu-amd

    # === CPU-specific configurations ===
    # For AMD CPUs
    # inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-amd

    # For Intel CPUs
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-cpu-intel

    # === Other common modules ===
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc
    inputs.hydenix.inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };

    #! EDIT THIS USER (must match users defined below)
    users.ruslan =
      { ... }:
      {
        imports = [
          inputs.hydenix.lib.homeModules
          # Nix-index-database - for comma and command-not-found
          inputs.nix-index-database.hmModules.nix-index
          ./modules/hm
        ];
      };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;

  # IMPORTANT: Customize the following values to match your preferences
  hydenix = {
    enable = true; # Enable the Hydenix module

    #! EDIT THESE VALUES
    hostname = "ruslan-nixos"; # Change to your preferred hostname
    timezone = "Europe/Kyiv"; # Change to your timezone
    locale = "en_US.UTF-8"; # Change to your preferred locale

    /*
      Optionally edit the below values, or leave to use hydenix defaults
      visit ./modules/hm/default.nix for more options
    */

    audio.enable = true; # enable audio module
    boot = {
      # enable = true; # enable boot module
      useSystemdBoot = false; # disable for GRUB
      grubTheme = "Retroboot"; # or "Pochita"
      grubExtraConfig = ""; # additional GRUB configuration
      kernelPackages = pkgs.linuxPackages_zen; # default zen kernel
    };
    gaming.enable = true; # enable gaming module
    hardware.enable = true; # enable hardware module
    network.enable = true; # enable network module
    nix.enable = true; # enable nix module
    sddm = {
      enable = true; # enable sddm module
      theme = "Candy"; # or "Corners"
    };
    system.enable = true; # enable system module
  };

  users.groups.ruslan = {};

  #! EDIT THESE VALUES (must match users defined above)
  users.users.ruslan = {
    isNormalUser = true; # Regular user account
    group = "ruslan";
    extraGroups = [
      "wheel" # For sudo access
      "networkmanager" # For network management
      "video" # For display/graphics access
      "docker" # For Docker access
      # Add other groups as needed
    ];
    shell = pkgs.zsh; # Change if you prefer a different shell
  };

  boot.initrd.luks.devices."data-encrypted" = {
    device = "/dev/nvme0n1p5";
    preLVM = true;
  };

  # Подключаем как обычную файловую систему
  fileSystems."/mnt/data-encrypted" = {
    device = "/dev/mapper/data-encrypted";
    fsType = "ext4";
    options = [ "nofail" "noatime" ];
  };

  system.stateVersion = "25.05";
}
