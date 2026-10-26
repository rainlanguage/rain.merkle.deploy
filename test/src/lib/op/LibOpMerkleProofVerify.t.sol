// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {Test} from "forge-std-1.17.0/src/Test.sol";
import {LibOpMerkleProofVerify, OperandV2, StackItem} from "src/lib/op/LibOpMerkleProofVerify.sol";
import {Hashes} from "@openzeppelin-contracts-5.7.0/utils/cryptography/Hashes.sol";
import {MerkleProof} from "@openzeppelin-contracts-5.7.0/utils/cryptography/MerkleProof.sol";
import {ROOT, LEAF0_0, LEAF0_0_INNER, PROOF0_0, LEAF1_0, LEAF1_0_INNER, PROOF1_0} from "test/proof/LibTestProof.sol";

contract LibOpMerkleProofVerifyTest is Test {
    function testIntegrityEnoughInputs(OperandV2 operand, uint256 inputs, uint256 outputs) external pure {
        inputs = bound(inputs, 3, type(uint256).max);
        (uint256 calculatedInputs, uint256 calculatedOutputs) =
            LibOpMerkleProofVerify.integrity(operand, inputs, outputs);
        assertEq(calculatedInputs, inputs);
        assertEq(calculatedOutputs, 1);
    }

    function testIntegrityNotEnoughInputs(OperandV2 operand, uint256 inputs, uint256 outputs) external pure {
        inputs = bound(inputs, 0, 2);
        (uint256 calculatedInputs, uint256 calculatedOutputs) =
            LibOpMerkleProofVerify.integrity(operand, inputs, outputs);
        assertEq(calculatedInputs, 3);
        assertEq(calculatedOutputs, 1);
    }

    function run3(OperandV2 operand, bytes32 root, bytes32 leaf, bytes32 proof) internal pure returns (bytes32) {
        StackItem[] memory inputs = new StackItem[](3);
        inputs[0] = StackItem.wrap(root);
        inputs[1] = StackItem.wrap(leaf);
        inputs[2] = StackItem.wrap(proof);
        StackItem[] memory outputs = LibOpMerkleProofVerify.run(operand, inputs);
        assertEq(outputs.length, 1);
        return StackItem.unwrap(outputs[0]);
    }

    function testRunStandardLeafInnerHashVerifies(OperandV2 operand) external pure {
        assertEq(run3(operand, ROOT, LEAF0_0_INNER, PROOF0_0), bytes32(uint256(1)), "leaf 0");
        assertEq(run3(operand, ROOT, LEAF1_0_INNER, PROOF1_0), bytes32(uint256(1)), "leaf 1");
    }

    function testRunOuterLeafHashRejected(OperandV2 operand) external pure {
        assertEq(run3(operand, ROOT, LEAF0_0, PROOF0_0), 0, "leaf 0");
        assertEq(run3(operand, ROOT, LEAF1_0, PROOF1_0), 0, "leaf 1");
    }

    function testRunInternalNodeRejectedAsLeaf(OperandV2 operand, bytes32[4] memory inners) external pure {
        bytes32[4] memory leaves;
        for (uint256 i = 0; i < 4; i++) {
            leaves[i] = keccak256(bytes.concat(inners[i]));
        }
        bytes32 n01 = Hashes.commutativeKeccak256(leaves[0], leaves[1]);
        bytes32 n23 = Hashes.commutativeKeccak256(leaves[2], leaves[3]);
        bytes32 root = Hashes.commutativeKeccak256(n01, n23);

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = n23;
        assertTrue(MerkleProof.verify(proof, root, n01), "n01 is an internal node of the tree");

        assertEq(run3(operand, root, n01, n23), 0, "internal node");
        (bytes32 a, bytes32 b) = leaves[0] < leaves[1] ? (leaves[0], leaves[1]) : (leaves[1], leaves[0]);
        assertEq(run3(operand, root, keccak256(abi.encode(a, b)), n23), 0, "single-hashed internal node preimage");
    }

    function testRunSingleHashedTreeLeafRejected(OperandV2 operand, bytes32 inner0, bytes32 inner1) external pure {
        bytes32 root = Hashes.commutativeKeccak256(inner0, inner1);

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = inner1;
        assertTrue(MerkleProof.verify(proof, root, inner0), "inner0 is a leaf of the single-hashed tree");

        assertEq(run3(operand, root, inner0, inner1), 0);
    }

    function testRunUnhappy(OperandV2 operand, StackItem[] memory inputs) external pure {
        vm.assume(inputs.length > 2);

        StackItem[] memory outputs = LibOpMerkleProofVerify.run(operand, inputs);

        assertEq(outputs.length, 1);
        assertEq(StackItem.unwrap(outputs[0]), 0, "Merkle proof should be invalid");
    }
}
