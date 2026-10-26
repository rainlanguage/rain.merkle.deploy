// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {AuthoringMetaV2} from "rainlang-0.2.27/src/interface/deprecated/v1/IParserV1.sol";

uint256 constant SUB_PARSER_WORD_MERKLE_PROOF_VERIFY = 0;
uint256 constant SUB_PARSER_WORD_PARSERS_LENGTH = 1;

/// @title LibMerkleSubParser
/// @notice Provides authoring metadata for the Merkle sub-parser to match the
/// op implementation in LibOpMerkleProofVerify.
library LibMerkleSubParser {
    function authoringMetaV2() internal pure returns (bytes memory) {
        AuthoringMetaV2[] memory meta = new AuthoringMetaV2[](SUB_PARSER_WORD_PARSERS_LENGTH);

        meta[SUB_PARSER_WORD_MERKLE_PROOF_VERIFY] = AuthoringMetaV2(
            "merkle-proof-verify",
            "Verifies a proof of a leaf in an Open Zeppelin StandardMerkleTree; other tree formats are not supported. Returns 1 if the proof is valid, else 0. First input is the merkle root. Second is the leaf values hashed once, `hash(values...)`; the word applies the outer leaf hash itself. Tail are the proof values."
        );
        return abi.encode(meta);
    }
}
