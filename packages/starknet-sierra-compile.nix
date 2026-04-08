{
  lib,
  pkgs,
  ...
}: let
  version = "2.13.1";
  cairoRelease = builtins.fetchurl {
    url = "https://github.com/starkware-libs/cairo/releases/download/v${version}/release-x86_64-unknown-linux-musl.tar.gz";
    sha256 = "sha256:09l93m8if91yz418cndibicczl0h9va9fxcm8s80b1j7f6lk1s8f";
  };

  artifacts = pkgs.stdenv.mkDerivation {
    name = "cairo-release-artifacts";
    src = cairoRelease;
    phases = ["unpackPhase"];
    unpackPhase = ''
      mkdir -p $out
      tar -xzf $src -C $out
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    name = "starknet-sierra-compile";
    src = artifacts;
    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
      mkdir -p $out/bin
      cp ./cairo/bin/starknet-sierra-compile $out/bin/
      chmod +x $out/bin/starknet-sierra-compile
    '';
  }
