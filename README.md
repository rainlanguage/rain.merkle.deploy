# rain.merkle.deploy

Exposes the merkle proof logic from Open Zeppelin 5.x to rainlang as a single
subparsed word `merkle-proof-verify`, and carries the deterministic deploy
record of the concrete `MerkleWords` subparser/extern.

The usage is as per the
[Open Zeppelin documentation](https://docs.openzeppelin.com/contracts/5.x/api/utils/cryptography#MerkleProof-verify-bytes32---bytes32-bytes32-),
where the first argument to `merkle-proof-verify` is the root, the second is the
leaf and the tail is the proof.

As merkle proofs have a length that depends on the size of the merkle tree the
proof is for, the rainlang word is variadic. The whole tail is used as the proof
but must be at least length 1.

Note that the `merkle-proof-verify` word returns `0` or `1` where `1` indicates
that the proof is valid. The rainlang author is responsible for applying
`ensure` to the return value to revert the transaction on invalid proofs if that
is the desired behaviour.

## The deploy record

Follows the [`rain.deploy`](https://github.com/rainlanguage/rain.deploy)
standard:

- `src/abstract/MerkleWordsDeploySuites.sol` declares the `merkle-words`
  candidate and the released suites read from the generated `LibReleasedSuites`.
- `script/Build.sol` regenerates, from one compile, the rolling snapshot
  `src/generated/candidate/MerkleWords.sol` (Zoltu address, codehash, creation
  and runtime bytecode, dependencies), its alias lib
  `src/lib/LibMerkleWordsDeploy.sol`, and the parse meta and function pointers
  in `src/generated/MerkleWordsPointers.sol`.
- `script/build-meta.sh` regenerates the proof fixtures and
  `meta/MerkleWords.rain.meta`, whose hash the pointers carry.

## Releases

Deploy first, by dispatching `Manual sol artifacts` for the `merkle-words`
suite. Then release `rain-merkle-deploy` with a manual `sol-v*` tag; tagging
never broadcasts.
