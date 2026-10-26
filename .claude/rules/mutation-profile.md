---
paths:
  - "src/**"
  - "test/**"
  - "foundry.toml"
---

# Mutation and coverage campaigns run under `FOUNDRY_PROFILE=mutation`

```bash
nix develop -c bash -c 'FOUNDRY_PROFILE=mutation forge test'
```

`MerkleWordsDeploySnapshotTest` and `MerkleWordsPointersTest` pin compiler
output, so they fail under every source mutation whether or not the mutated
behaviour is observable. `[profile.mutation]` excludes both; the default profile
keeps them for CI.
