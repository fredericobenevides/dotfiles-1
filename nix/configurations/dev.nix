{ stdenv, fetchFromGitHub, pkgs, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = [ "28" ];
    abiVersions = [ "x86" "x86_64" ];
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
      custom-python-packages = python-packages:
        with python-packages; [
          # pandas
          # jupyter
          # matplotlib
          # virtualenvwrapper
          python-language-server
          pybluez
          # bluepy
          # seaborn
          # pillow
          fonttools
          pip
        ];
      python-with-my-packages =
        stable.python37Full; # .withPackages custom-python-packages;
    in [
      android-studio
      android.androidsdk
      stable.awscli
      docker-compose
      gitAndTools.hub
      go
      nodejs-12_x
      python-with-my-packages
      shellcheck
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

  users.users.greg.extraGroups = [ "docker" "vboxusers" ];
}
