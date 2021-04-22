{ pkgs, ... }:

{
  # home.stateVersion = "20.09";

  home.packages = with pkgs; [
    google-drive-ocamlfuse
  ];

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;

      package = pkgs.gitAndTools.hub;
    };

    vim = {
      enable = true;
      plugins = [ ];
    };
  };
}
