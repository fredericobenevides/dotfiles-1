{ stdenv, fetchFromGitHub, pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64"];
    includeEmulator = true;
    includeSystemImages = true;
    useGoogleAPIs = true;
    includeSources = true;
  };

  android-sdk-path = "${android.androidsdk}/libexec/android-sdk";

in {
  nixpkgs.config.android_sdk.accept_license = true;
 
  environment.systemPackages = with pkgs;
   
  let
    custom-python-packages = python-packages: with python-packages; [
      # pandas
      # jupyter
      # matplotlib
      # virtualenvwrapper
      # python-language-server
      # seaborn
      # pillow
      fonttools
    ];
    python-with-my-packages = python37Full.withPackages custom-python-packages;
    vcsodeWithExtension = vscode-with-extensions.override {
      # When the extension is already available in the default extensions set.
      vscodeExtensions = with vscode-extensions; [
        bbenoist.Nix
        python
      ]
      # Concise version from the vscode market place when not available in the default set.
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.6.33";
          sha256 = "166ia73vrcl5c9hm4q1a73qdn56m0jc7flfsk5p5q41na9f10lb0";
        }
        {
          name = "dart-code";
          publisher = "dart-code";
          version = "3.9.1";
          sha256 = "02fmbrikpf1hp98w0b8qy1940ir2pjzqxb00fpv5qmrn0qgr581r";
        }
        {
          name = "flutter";
          publisher = "dart-code";
          version = "3.12.1";
          sha256 = "1lqsivqf4kmgih1wv44bvjwm2h1yxhpz7ij57d1jlf63r65xy2d3";
        }
        {
          name = "debugger-for-chrome";
          publisher = "msjsdiag";
          version = "4.12.6";
          sha256 = "1dlplz72830shqbi7zkgg7pb45ijwajwhkmapx4lmlw13z41jw1g";
        }
        {
          name = "js-debug-nightly";
          publisher = "ms-vscode";
          version = "2020.5.1217";
          sha256 = "18ysb0f7rind40xh4qhrrjkxkibhzh6sp9xvdfycpn9j1mgmywv8";
        }
        {
          name = "vscode-java-debug";
          publisher = "vscjava";
          version = "0.26.0";
          sha256 = "1vymb8ivnv05jarjm2l03s9wsqmakgsrlvf3s3d43jd3ydpi2jfy";
        }
        {
          name = "java";
          publisher = "redhat";
          version = "0.61.0";
          sha256 = "1mnqzlzscy6wnzh6h8yjhz190z6wvhkp4g8db151haz4jvxrfhnn";
        }
      ];
    };

    hover = (import (fetchTarball https://github.com/ericdallo/nixpkgs/archive/hover-flutter.tar.gz) {}).hover;
    clojure-lsp = (import (fetchTarball https://github.com/NixOS/nixpkgs/archive/master.tar.gz) {}).clojure-lsp;
  in
    [
      android-studio
      android.androidsdk
      awscli
      clojure
      clojure-lsp
      cmake
      dart_dev
      docker-compose
      # (eclipses.eclipseWithPlugins {
      #   eclipse = eclipses.eclipse-java;
      #   jvmArgs = [ "-Xms6000m" "-Xmx8096m" ];
      #   plugins = with eclipses.plugins;
      #     [ gradle ];
      # })
      ((emacsPackagesGen emacsUnstable).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
      # flutter
      gitAndTools.hub
      go
      heroku
      hover
      joker
      # clj-kondo
      leiningen
      mysql
      nodejs
      nodePackages.node2nix
      pandoc
      python-with-my-packages
      rust-analyzer
      rustup
      latest.rustChannels.nightly.rust
      sass
      sassc
      shellcheck
      vcsodeWithExtension
    ];

  environment.variables = {
    ANDROID_SDK_ROOT = android-sdk-path;
    ANDROID_HOME = android-sdk-path;
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk11;
    };

    adb.enable = true;
  };

  services.emacs = with pkgs; {
    enable = true;
    defaultEditor = true;
    package = ((emacsPackagesGen emacsUnstable).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]));
  };

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];

}
