{
  description = "MCP server for Tasker on Android";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (
        _system: pkgs: rec {
          tasker-mcp = pkgs.callPackage ./nix/package.nix { };
          default = tasker-mcp;
        }
      );

      # pkgs.tasker-mcp for a NixOS or Home Manager configuration.
      overlays.default = final: _prev: {
        tasker-mcp = final.callPackage ./nix/package.nix { };
      };

      apps = forAllSystems (
        system: _pkgs: {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/tasker-mcp";
          };
        }
      );

      devShells = forAllSystems (
        _system: pkgs: {
          default = pkgs.mkShell {
            packages = [
              pkgs.nodejs_26
              pkgs.git
            ];
          };
        }
      );

      formatter = forAllSystems (_system: pkgs: pkgs.nixfmt);
    };
}
