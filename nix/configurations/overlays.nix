[
  (self: super: with super; {
    stable = import (fetchTarball http://nixos.org/channels/nixos-21.05/nixexprs.tar.xz) {};
    master = import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {};
  })

  # (import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
]
