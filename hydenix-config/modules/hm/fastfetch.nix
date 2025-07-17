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
}
