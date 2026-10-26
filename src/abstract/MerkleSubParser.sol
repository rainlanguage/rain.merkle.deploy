// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {OPCODE_MERKLE_PROOF_VERIFY} from "./MerkleExtern.sol";
import {
    OperandV2,
    BaseRainlangSubParser,
    IParserToolingV1,
    ISubParserToolingV1
} from "rainlang-0.2.30/src/abstract/BaseRainlangSubParser.sol";
import {LibSubParse} from "rainlang-0.2.30/src/lib/parse/LibSubParse.sol";
import {LibConvert} from "rain-lib-typecast-0.1.4/src/LibConvert.sol";
import {SUB_PARSER_WORD_PARSERS_LENGTH, SUB_PARSER_WORD_MERKLE_PROOF_VERIFY} from "../lib/parse/LibMerkleSubParser.sol";
import {IInterpreterExternV4} from "rainlang-0.2.30/src/interface/IInterpreterExternV4.sol";
import {LibParseOperand} from "rainlang-0.2.30/src/lib/parse/LibParseOperand.sol";
import {
    OPERAND_HANDLER_FUNCTION_POINTERS as SUB_PARSER_OPERAND_HANDLERS,
    PARSE_META as SUB_PARSER_PARSE_META,
    SUB_PARSER_WORD_PARSERS
} from "../generated/MerkleWordsPointers.sol";

uint8 constant PARSE_META_BUILD_DEPTH = 1;

/// @title MerkleSubParser
/// Boilerplate implementation of a sub-parser exposing the merkle proof logic
/// from the MerkleExtern as a rainlang word.
abstract contract MerkleSubParser is BaseRainlangSubParser {
    /// @inheritdoc BaseRainlangSubParser
    function subParserParseMeta() internal pure override returns (bytes memory) {
        return SUB_PARSER_PARSE_META;
    }

    /// @inheritdoc BaseRainlangSubParser
    function subParserWordParsers() internal pure override returns (bytes memory) {
        return SUB_PARSER_WORD_PARSERS;
    }

    /// @inheritdoc BaseRainlangSubParser
    function subParserOperandHandlers() internal pure override returns (bytes memory) {
        return SUB_PARSER_OPERAND_HANDLERS;
    }

    /// @inheritdoc IParserToolingV1
    function buildOperandHandlerFunctionPointers() external pure returns (bytes memory) {
        function(bytes32[] memory) internal pure returns (OperandV2)[] memory fs =
            new function(bytes32[] memory) internal pure returns (OperandV2)[](SUB_PARSER_WORD_PARSERS_LENGTH);
        fs[SUB_PARSER_WORD_MERKLE_PROOF_VERIFY] = LibParseOperand.handleOperandDisallowed;

        uint256[] memory pointers;
        assembly ("memory-safe") {
            pointers := fs
        }
        return LibConvert.unsafeTo16BitBytes(pointers);
    }

    /// @inheritdoc IParserToolingV1
    function buildLiteralParserFunctionPointers() external pure returns (bytes memory) {
        return "";
    }

    /// @inheritdoc ISubParserToolingV1
    function buildSubParserWordParsers() external pure returns (bytes memory) {
        function(uint256, uint256, OperandV2) internal view returns (bool, bytes memory, bytes32[] memory)[] memory fs = new function(uint256, uint256, OperandV2)
        internal
        view returns (bool, bytes memory, bytes32[] memory)[](SUB_PARSER_WORD_PARSERS_LENGTH);
        fs[SUB_PARSER_WORD_MERKLE_PROOF_VERIFY] = merkleProofVerifySubParser;

        uint256[] memory pointers;
        assembly ("memory-safe") {
            pointers := fs
        }
        return LibConvert.unsafeTo16BitBytes(pointers);
    }

    // slither-disable-next-line dead-code
    function merkleProofVerifySubParser(uint256 constantsHeight, uint256 ioByte, OperandV2 operand)
        internal
        view
        returns (bool, bytes memory, bytes32[] memory)
    {
        // slither-disable-next-line unused-return
        return LibSubParse.subParserExtern(
            IInterpreterExternV4(extern()), constantsHeight, ioByte, operand, OPCODE_MERKLE_PROOF_VERIFY
        );
    }

    // slither-disable-next-line dead-code
    function extern() internal view virtual returns (address) {
        return address(this);
    }
}
