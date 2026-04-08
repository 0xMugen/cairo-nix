{
  lib,
  pkgs,
  ...
}: let
  version = "0.4.2";
  src = pkgs.fetchFromGitHub {
    owner = "xJonathanLEI";
    repo = "starkli";
    rev = "v${version}";
    hash = "sha256-9eIlZWdscnZHBRCkAQxoM+xk/GD9HAKvbffVq3Ntjws=";
  };

  rustPlatform = pkgs.makeRustPlatform {
    cargo = pkgs.rust-bin.stable."1.83.0".minimal;
    rustc = pkgs.rust-bin.stable."1.83.0".minimal;
  };
in
  rustPlatform.buildRustPackage {
    inherit src version;
    pname = "starkli";

    nativeBuildInputs = with pkgs; [
      pkg-config
      openssl
      perl
    ];

    # https://discourse.nixos.org/t/rust-openssl-woes/12340
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

    useFetchCargoVendor = true;
    cargoHash = "sha256-OTOAzkX9q8fsJvowLj5Uk+Kj3S5BCbs7boP7AaKjEsw=";
  }
