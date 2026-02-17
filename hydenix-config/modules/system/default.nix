{ pkgs, ... }:

{
  imports = [
    # ./example.nix - add your modules here
    # ./video.nix
  ];

  # environment.systemPackages = [
  #   # pkgs.vscode - hydenix's vscode version
  #   # pkgs.userPkgs.vscode - your personal nixpkgs version
  # ];

  environment.systemPackages = with pkgs; [
    cryptsetup
    xclip
    unzip
    gcc
    gnumake
    binutils
    lua5_1
    lua5_1.pkgs.luarocks
    ripgrep
    nodejs
    wlsunset
    ncdu
    git-lfs
    wget
    mpv
    obs-studio
    rdfind
    slack
    zoom-us
    mysql-workbench
    cloudflare-warp
    tree
    docker
    docker-buildx
    docker-compose
    mysql80.client
    libreoffice-still
    bat
    tty-clock
    clock-rs
    tree-sitter
    dotnet-sdk
    omnisharp-roslyn
    # gnome-keyring
    # libsecret
    google-chrome
    rpi-imager
    realvnc-vnc-viewer
  ];

  environment.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}/share/dotnet";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  systemd.services.warp-svc = {
    enable = true;
    description = "Cloudflare Warp Service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.cloudflare-warp ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
    };
  };

  # programs.git = {
  #   enable = true;
  #   lfs.enable = true;
  # };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "log-driver" = "json-file";
      "log-opts" = {
        "max-size" = "10m";
        "max-file" = "3";
        "labels" = "production_status";
        "env" = "os,customer";
      };
    };
  };

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
  zramSwap.memoryPercent = 90;
  zramSwap.priority = 100;

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
  };

  networking.extraHosts = ''
    127.0.0.1 local.ptprocover.com
  '';

  # services.gnome-keyring = {
  #   enable = true;
  #   components = [ "pkcs11" "secrets" "ssh" ];
  # };

  services.gnome.gnome-keyring.enable = true;

  # boot.kernelParams = [
  #   "battery.charge_control_end_threshold=80"
  #   "battery.charge_control_start_threshold=75"
  # ];

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80"
  #   SUBSYSTEM=="power_supply", ATTR{charge_control_start_threshold}="75"
  # '';

  systemd.services.battery-charge-thresholds = {
    description = "Set battery charge thresholds";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "/bin/sh -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'"
        "/bin/sh -c 'echo 75 > /sys/class/power_supply/BAT0/charge_control_start_threshold'"
      ];
    };
  };
}
