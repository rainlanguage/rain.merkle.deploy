// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {OperandV2, StackItem} from "rainlang-interface-0.2.13/src/interface/IInterpreterV4.sol";
import {MerkleProof} from "@openzeppelin-contracts-5.7.0/utils/cryptography/MerkleProof.sol";

/// @title LibOpMerkleProofVerify
/// Provides implementation and boilerplate to expose merkle proof verification
/// of Open Zeppelin `StandardMerkleTree` leaves as a rain interpreter extern.
library LibOpMerkleProofVerify {
    function integrity(OperandV2, uint256 inputs, uint256) internal pure returns (uint256, uint256) {
        // Merkle proof requires dynamic proof inputs and produces 1 output.
        // Inputs must be at least 3: the root, the leaf, and at least one proof.
        return (inputs < 3 ? 3 : inputs, 1);
    }

    /// Verifies a Merkle proof of a `StandardMerkleTree` leaf.
    /// The first two elements of the input array are the root and the leaf's
    /// inner hash `keccak256(abi.encode(values))`. The op applies the outer hash
    /// `keccak256(bytes.concat(inner))` itself, so an internal node cannot pass
    /// as a leaf.
    /// The rest of the elements are the Merkle proof. The length of the proof is
    /// implied by the structure of the rainlang, but must be at least 1.
    /// Returns a single value; 1 if the proof is valid, 0 otherwise.
    function run(OperandV2, StackItem[] memory inputs) internal pure returns (StackItem[] memory) {
        bytes32 root;
        bytes32 innerLeaf;
        bytes32[] memory proof;

        assembly ("memory-safe") {
            // The first input is the root of the Merkle tree.
            root := mload(add(inputs, 0x20))
            // The second input is the inner hash of the leaf to verify.
            innerLeaf := mload(add(inputs, 0x40))
            // The rest are the Merkle proof elements.
            // Mutate the inputs array to be a proof elements array.
            let proofLength := sub(mload(inputs), 2)
            proof := add(inputs, 0x40)
            mstore(proof, proofLength)
        }

        bytes32 leaf = keccak256(bytes.concat(innerLeaf));
        uint256 isValid = MerkleProof.verify(proof, root, leaf) ? 1 : 0;
        assembly ("memory-safe") {
            // We can mutate inputs again to be outputs.
            mstore(inputs, 1)
            mstore(add(inputs, 0x20), isValid)
        }
        return inputs;
    }
}
