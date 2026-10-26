# CLAUDE.md

## Project

rain.merkle.deploy exposes OpenZeppelin's merkle proof verification to rainlang
as the subparsed word `merkle-proof-verify`, and is the deploy repo for the
concrete `MerkleWords` subparser/extern. The abstracts, libraries, generated
pointers and the deploy record all live here, so the pointers are generated from
the same compile that is deployed.

License: LicenseRef-DCL-1.0. All source files carry SPDX headers.

## Build & Test

```bash
nix develop -c forge soldeer install
nix develop -c forge build
nix develop -c forge test
./script/build-meta.sh
nix develop -c forge script ./script/Build.sol && ./script/build.sh
nix develop -c forge fmt
nix develop -c slither .
nix develop -c reuse lint
```

`script/Build.sol` reads the compile it starts with, so a change that moves the
pointers needs a second run before the snapshot matches.

Mutation and coverage campaigns: see `.claude/rules/mutation-profile.md`.

## Layout

- `src/concrete/MerkleWords.sol` — the deployed contract.
- `src/abstract/MerkleExtern.sol`, `src/abstract/MerkleSubParser.sol`,
  `src/lib/op/`, `src/lib/parse/` — the word implementation.
- `src/abstract/MerkleWordsDeploySuites.sol` — the one declaration of what this
  repo deploys, inherited by the deploy script, the build script and the
  verification tests.
- `src/generated/MerkleWordsPointers.sol` — parse meta and function pointers.
- `src/generated/candidate/MerkleWords.sol` — the rolling deploy snapshot.
  `src/generated/<tag>/` directories are frozen release records written by
  `cutRelease()`. NEVER edit generated files by hand.
- `src/lib/LibMerkleWordsDeploy.sol`, `src/lib/LibMerkleWordsReleased.sol`,
  `src/lib/LibReleasedSuites.sol` — generated.
- `meta/` — authoring meta and the CBOR meta `script/build-meta.sh` builds.
- `test/src/` mirrors `src/`; `test/src/abstract/` binds the declaration to the
  shipped rain-deploy verify abstracts.

## Conventions

- Concrete contracts, scripts and tests pin `=0.8.25`; libraries float
  `^0.8.25`.
- Cancun, optimizer on at 1000 runs, no CBOR metadata.
- Soldeer deps carry the version in the import path. `recursive_deps` is off, so
  every package an import resolves through is declared in `foundry.toml`.
- Comments describe current behaviour only.

## Deployment and releases

Deployed via the Zoltu deployer. A deploy is a human-dispatched run of
`Manual sol artifacts`, never a merge, and comes BEFORE the tag. Releases are
manual `sol-v*` tags publishing `rain-merkle-deploy`.
