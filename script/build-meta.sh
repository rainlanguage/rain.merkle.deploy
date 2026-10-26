#!/usr/bin/env bash
# SPDX-License-Identifier: LicenseRef-DCL-1.0
# SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
# Regenerates the proof fixtures and `meta/MerkleWords.rain.meta`, which
# `script/Build.sol` hashes into the generated pointers. Runs in this repo's
# default devshell because `rain` and node are not in rainix sol-shell.
set -euo pipefail
cd "$(dirname "$0")/.."
nix develop -c bash -euxo pipefail -c '
  node test/proof/build.js
  mkdir -p meta
  forge script --silent ./script/BuildAuthoringMeta.sol
  rain meta build -i <(cat ./meta/MerkleSubParserAuthoringMeta.rain.meta) -m authoring-meta-v2 -t cbor -e deflate -l none -o meta/MerkleWords.rain.meta
'
