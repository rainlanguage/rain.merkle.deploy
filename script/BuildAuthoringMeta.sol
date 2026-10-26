// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {Script} from "forge-std-1.17.0/src/Script.sol";
import {LibMerkleSubParser} from "src/lib/parse/LibMerkleSubParser.sol";

/// @title Merkle subparser Authoring Meta
/// @notice A script that writes the raw authoring meta out to file so it can be
/// wrapped in CBOR and emitted on metaboard.
contract BuildAuthoringMeta is Script {
    function run() external {
        vm.writeFileBinary("meta/MerkleSubParserAuthoringMeta.rain.meta", LibMerkleSubParser.authoringMetaV2());
    }
}
