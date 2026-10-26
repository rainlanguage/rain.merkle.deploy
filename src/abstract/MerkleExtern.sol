// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {
    BaseRainlangExtern,
    OperandV2,
    StackItem,
    IOpcodeToolingV1,
    IIntegrityToolingV1
} from "rainlang-0.2.27/src/abstract/BaseRainlangExtern.sol";
import {LibOpMerkleProofVerify} from "../lib/op/LibOpMerkleProofVerify.sol";
import {LibConvert} from "rain-lib-typecast-0.1.4/src/LibConvert.sol";

import {OPCODE_FUNCTION_POINTERS, INTEGRITY_FUNCTION_POINTERS} from "../generated/MerkleWordsPointers.sol";

uint256 constant OPCODE_MERKLE_PROOF_VERIFY = 0;
uint256 constant OPCODE_FUNCTION_POINTERS_LENGTH = 1;

/// @title MerkleExtern
/// Boilerplate implementation to expose merkle proof verification opcode lib
/// for Open Zeppelin 5.x logic as an abstract rain interpreter extern contract.
abstract contract MerkleExtern is BaseRainlangExtern {
    /// @inheritdoc BaseRainlangExtern
    function opcodeFunctionPointers() internal pure override returns (bytes memory) {
        return OPCODE_FUNCTION_POINTERS;
    }

    /// @inheritdoc BaseRainlangExtern
    function integrityFunctionPointers() internal pure override returns (bytes memory) {
        return INTEGRITY_FUNCTION_POINTERS;
    }

    /// @inheritdoc IOpcodeToolingV1
    function buildOpcodeFunctionPointers() external pure returns (bytes memory) {
        function(OperandV2, StackItem[] memory) internal view returns (StackItem[] memory)[] memory fs = new function(OperandV2, StackItem[] memory)
        internal
        view returns (StackItem[] memory)[](OPCODE_FUNCTION_POINTERS_LENGTH);
        fs[OPCODE_MERKLE_PROOF_VERIFY] = LibOpMerkleProofVerify.run;

        uint256[] memory pointers;
        assembly ("memory-safe") {
            pointers := fs
        }
        return LibConvert.unsafeTo16BitBytes(pointers);
    }

    /// @inheritdoc IIntegrityToolingV1
    function buildIntegrityFunctionPointers() external pure returns (bytes memory) {
        function(OperandV2, uint256, uint256) internal pure returns (uint256, uint256)[] memory fs = new function(OperandV2, uint256, uint256)
        internal
        pure returns (uint256, uint256)[](OPCODE_FUNCTION_POINTERS_LENGTH);
        fs[OPCODE_MERKLE_PROOF_VERIFY] = LibOpMerkleProofVerify.integrity;

        uint256[] memory pointers;
        assembly ("memory-safe") {
            pointers := fs
        }
        return LibConvert.unsafeTo16BitBytes(pointers);
    }
}
