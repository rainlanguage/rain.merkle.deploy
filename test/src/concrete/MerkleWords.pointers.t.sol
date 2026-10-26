// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {Test} from "forge-std-1.17.0/src/Test.sol";
import {MerkleWords} from "src/concrete/MerkleWords.sol";
import {
    BYTECODE_HASH,
    OPCODE_FUNCTION_POINTERS,
    INTEGRITY_FUNCTION_POINTERS,
    OPERAND_HANDLER_FUNCTION_POINTERS,
    SUB_PARSER_WORD_PARSERS
} from "src/generated/MerkleWordsPointers.sol";

/// @title MerkleWordsPointersTest
/// @notice The generated function pointer tables and codehash index into the
/// compiled `MerkleWords`.
contract MerkleWordsPointersTest is Test {
    function testMerkleWordsCodehashIsTheGeneratedCodehash() external {
        assertEq(address(new MerkleWords()).codehash, BYTECODE_HASH);
    }

    function testMerkleWordsOpcodeFunctionPointers() external {
        assertEq(new MerkleWords().buildOpcodeFunctionPointers(), OPCODE_FUNCTION_POINTERS);
    }

    function testMerkleWordsIntegrityFunctionPointers() external {
        assertEq(new MerkleWords().buildIntegrityFunctionPointers(), INTEGRITY_FUNCTION_POINTERS);
    }

    function testMerkleWordsOperandHandlerFunctionPointers() external {
        assertEq(new MerkleWords().buildOperandHandlerFunctionPointers(), OPERAND_HANDLER_FUNCTION_POINTERS);
    }

    function testMerkleWordsSubParserWordParsers() external {
        assertEq(new MerkleWords().buildSubParserWordParsers(), SUB_PARSER_WORD_PARSERS);
    }
}
