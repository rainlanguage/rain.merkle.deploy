{
  description = "Flake for development workflows.";

  inputs = {
    rainix.url = "github:rainprotocol/rainix";
    rain.url = "github:rainlanguage/rain.cli";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      flake-utils,
      rainix,
      rain,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = rainix.pkgs.${system};
      in
      rec {
        packages = {
          rain-merkle-deploy-prelude = rainix.mkTask.${system} {
            name = "rain-merkle-deploy-prelude";
            body = ''
              set -euxo pipefail

              node test/proof/build.js;

              mkdir -p meta;
              forge script --silent ./script/BuildAuthoringMeta.sol;
              rain meta build \
                -i <(cat ./meta/MerkleSubParserAuthoringMeta.rain.meta) \
                -m authoring-meta-v2 \
                -t cbor \
                -e deflate \
                -l none \
                -o meta/MerkleWords.rain.meta \
                ;
            '';
          };
        }
        // rainix.packages.${system};

        devShells.default = pkgs.mkShell {
          packages = [
            packages.rain-merkle-deploy-prelude
            rain.defaultPackage.${system}
          ];

          inherit (rainix.devShells.${system}.default) shellHook buildInputs nativeBuildInputs;

        };
      }
    );

}
