{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zmk = {
      # Per key/layer RGB underglow
      url = "github:moergo-sc/zmk/pull/36/head";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    zmk,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    firmware = import zmk {inherit pkgs;};
    keymap = "${self}/keymap.zmk";
    kconfig = "${self}/glove80.conf";
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
