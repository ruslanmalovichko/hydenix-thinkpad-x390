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
  ];

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
  zramSwap.memoryPercent = 75;
  zramSwap.priority = 100;

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
  };
}
