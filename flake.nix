{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zmk = {
      url = "github:moergo-sc/zmk";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    zmk,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    firmware = import zmk {inherit pkgs;};
    keymap = ./keymap.zmk;
    kconfig = ./glove80.conf;
    override = orig: orig.override {inherit keymap kconfig;};
    glove80 = with firmware;
      combine_uf2 (override glove80_left) (override glove80_right);
  in {
    packages.${system} = {
      inherit glove80;
      default = glove80;
    };
  };
}
