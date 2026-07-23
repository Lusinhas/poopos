{
  description = "P03 image application set. Empty by default — add packages with `nixpkg add`, or list them in `apps` below and run `nixpkg sync`.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      apps = with pkgs; [ ];
    in
    {
      packages.${system} = {
        default = pkgs.buildEnv {
          name = "p03-apps";
          paths = apps;
          extraOutputsToInstall = [
            "man"
            "share"
          ];
        };
      };
    };
}
