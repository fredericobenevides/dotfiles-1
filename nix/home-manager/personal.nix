{ pkgs, config, ... }:
let
  dotfilesDir = "$HOME/.dotfiles";
  nixpkgsUnstable = import <nixpkgs-unstable> { };

in {
  imports = [
    ./programs/common.nix
    ./programs/clojure.nix
    ./programs/vscode.nix
    ./programs/gregflix.nix
  ];

  home = {
    packages = with pkgs; [
      alda
      blender
      nixpkgsUnstable.graalvm11-ce
      heroku
      imagemagick
      mysql
      nodePackages.node2nix
      omnisharp-roslyn
      hugo
      polylith
      pandoc
      postman
      ferdi
      rust-analyzer
      s3cmd
      sass
      sassc
      srt-to-vtt-cl
      rustup
      skype
      teamviewer
      unityhub
      websocat
      dart
      flutter
      hover
    ];
    activation.linkFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      cp -n ${dotfilesDir}/.critical-keys.sample ~/.critical-keys

      ln -Tsf ${dotfilesDir}/.config/bspwm ~/.config/bspwm
      ln -Tsf ${dotfilesDir}/.config/sxhkd ~/.config/sxhkd
      ln -Tsf ${dotfilesDir}/.config/rofi ~/.config/rofi
      ln -Tsf ${dotfilesDir}/.config/polybar ~/.config/polybar
      ln -Tsf ${dotfilesDir}/.config/dunst ~/.config/dunst
      ln -Tsf ${dotfilesDir}/.config/libinput-gestures.conf ~/.config/libinput-gestures.conf
      ln -Tsf ${dotfilesDir}/.config/clojure ~/.config/clojure
      ln -Tsf ${dotfilesDir}/.config/gdfuse ~/.config/gdfuse
      ln -Tsf ${dotfilesDir}/.config/clj-kondo ~/.config/clj-kondo

      ln -Tsf ${dotfilesDir}/.doom.d ~/.doom.d
      ln -Tsf ${dotfilesDir}/.lsp ~/.lsp

      ln -sf ${dotfilesDir}/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.json
      ln -sf ${dotfilesDir}/.config/Code/User/settings.json ~/.config/Code/User/settings.json

      mkdir -p ~/.android/avd/device.avd
      ln -sf ${dotfilesDir}/nix/android/emulator-config.ini ~/.android/avd/device.avd/config.ini
    '';
  };
}
