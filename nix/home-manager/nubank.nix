{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
in {
  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nubank/nixpkgs/archive/master.tar.gz))
  ];

  imports = [
    ./programs/common.nix
    ./programs/vscode.nix
    ./programs/clojure.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home = {
    packages = with pkgs; [
      aws-iam-authenticator
      discord
      fzf
      gcc
      git-lfs
      hashdeep
      kubectl
      ferdi
      mob
      sassc
      yubikey-manager
      yubikey-personalization-gui
      visualvm
      tektoncd-cli
      xsv
      zoom-us
      insomnia
      nubank.dart
      nubank.flutter
      nubank.hover
    ];

    activation.linkFiles = config.lib.dag.entryAfter ["writeBoundary"] ''
        cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys
        ln -sf ${dotfilesDir}/.nubank_aliases ~/.nubank_aliases
        ln -sf ${dotfilesDir}/.nubank_extra ~/.extra

        ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
        ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
        ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
        ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
        ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
        ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
        ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse
        ln -Tsf ${dotfilesDir}/.config/clj-kondo ~/.config/clj-kondo

        ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
        ln -Tsf ${dotfilesDir}/.lsp ~/.lsp
        ln -sf ${dotfilesDir}/.midje.clj ~/.midje.clj
    '';
  };
}
