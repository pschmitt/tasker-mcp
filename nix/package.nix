{
  lib,
  buildNpmPackage,
  nodejs_26,
}:

buildNpmPackage {
  pname = "tasker-mcp";
  inherit (builtins.fromJSON (builtins.readFile ../package.json)) version;

  src = lib.cleanSource ../.;

  # Update with `nix run nixpkgs#prefetch-npm-deps -- package-lock.json` (or set
  # lib.fakeHash and read the hash from the failed build) whenever package-lock.json changes.
  npmDepsHash = "sha256-zGOabsVbolWkEsUCEatxRQ6yVoAO3lbUSTwT9+/g4tI=";

  # package.json requires Node >= 26.
  nodejs = nodejs_26;

  meta = {
    description = "MCP server for Tasker on Android";
    homepage = "https://github.com/pschmitt/tasker-mcp";
    license = lib.licenses.mit;
    mainProgram = "tasker-mcp";
  };
}
