{ lib, ... }:

{
  home.file.".config/fastfetch/logos" = lib.mkForce {
    source = ./../../files/logo;
    recursive = true;
    force = true;
  };

  home.file.".local/lib/hyde/fastfetch.sh" = lib.mkForce {
    source = ./../../files/fastfetch.sh;
    executable = true;
    mutable = true;
    force = true;
  };

  home.file.".config/fastfetch/config.jsonc" = lib.mkForce {
    source = ./../../files/config.jsonc;
    executable = true;
    force = true;
  };

  # hydenix.hm.shell.fastfetch.enable = false;
}
