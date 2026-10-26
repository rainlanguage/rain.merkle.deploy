// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {MerkleWords} from "src/concrete/MerkleWords.sol";
import {OpTest, StackItem} from "rainlang-0.2.19/test/abstract/OpTest.sol";
import {ExternIntegrityInputsMismatch} from "rainlang-0.2.19/src/error/ErrExtern.sol";
import {Strings} from "@openzeppelin-contracts-5.7.0/utils/Strings.sol";
import {
    ROOT,
    LEAF0_0_VALUE,
    LEAF0_0_AMOUNT,
    LEAF0_0_INNER,
    PROOF0_0,
    LEAF1_0_VALUE,
    LEAF1_0_AMOUNT,
    LEAF1_0_INNER,
    PROOF1_0
} from "test/proof/LibTestProof.sol";

contract MerkleWordsMerkleProofVerifyTest is OpTest {
    using Strings for address;
    using Strings for uint256;

    function checkStandardLeaf(address value, bytes32 amount, bytes32 inner, bytes32 proof) internal {
        MerkleWords merkleWords = new MerkleWords();

        StackItem[] memory expectedStack = new StackItem[](4);
        expectedStack[0] = StackItem.wrap(bytes32(uint256(1)));
        expectedStack[1] = StackItem.wrap(proof);
        expectedStack[2] = StackItem.wrap(inner);
        expectedStack[3] = StackItem.wrap(ROOT);

        checkHappy(
            bytes(
                string.concat(
                    "using-words-from ",
                    address(merkleWords).toHexString(),
                    "\n",
                    "root: ",
                    uint256(ROOT).toHexString(),
                    ",",
                    "leaf: hash(",
                    value.toHexString(),
                    " ",
                    uint256(amount).toHexString(),
                    "),",
                    "proof: ",
                    uint256(proof).toHexString(),
                    ",",
                    " _: merkle-proof-verify(root leaf proof);"
                )
            ),
            expectedStack,
            "merkle-proof-verify(root hash(value amount) proof)"
        );
    }

    function testMerkleWordsMerkleProofVerifyStandardTreeHashedValues() external {
        checkStandardLeaf(LEAF0_0_VALUE, LEAF0_0_AMOUNT, LEAF0_0_INNER, PROOF0_0);
        checkStandardLeaf(LEAF1_0_VALUE, LEAF1_0_AMOUNT, LEAF1_0_INNER, PROOF1_0);
    }

    function testMerkleWordsMerkleProofVerifyUnhappy(bytes32 proof, bytes32 leaf, bytes32 root) external {
        MerkleWords merkleWords = new MerkleWords();

        StackItem[] memory expectedStack = new StackItem[](4);
        expectedStack[0] = StackItem.wrap(0);
        expectedStack[1] = StackItem.wrap(proof);
        expectedStack[2] = StackItem.wrap(leaf);
        expectedStack[3] = StackItem.wrap(root);

        checkHappy(
            bytes(
                string.concat(
                    "using-words-from ",
                    address(merkleWords).toHexString(),
                    "\n",
                    "root: ",
                    uint256(root).toHexString(),
                    ",",
                    "leaf: ",
                    uint256(leaf).toHexString(),
                    ",",
                    "proof: ",
                    uint256(proof).toHexString(),
                    ",",
                    " _: merkle-proof-verify(root leaf proof);"
                )
            ),
            expectedStack,
            "merkle-proof-verify(root leaf proof)"
        );
    }

    function testMerkleWordsMerkleProofVerifyNoInputs() external {
        MerkleWords merkleWords = new MerkleWords();

        checkUnhappyParse2(
            bytes(
                string.concat(
                    "using-words-from ", address(merkleWords).toHexString(), "\n", " _: merkle-proof-verify();"
                )
            ),
            abi.encodeWithSelector(ExternIntegrityInputsMismatch.selector, 0, 3)
        );
    }

    function testMerkleWordsMerkleProofVerifyOnlyRoot(uint256 root) external {
        MerkleWords merkleWords = new MerkleWords();

        checkUnhappyParse2(
            bytes(
                string.concat(
                    "using-words-from ",
                    address(merkleWords).toHexString(),
                    "\n",
                    "root: ",
                    root.toHexString(),
                    ",",
                    " _: merkle-proof-verify(root);"
                )
            ),
            abi.encodeWithSelector(ExternIntegrityInputsMismatch.selector, 1, 3)
        );
    }

    function testMerkleWordsMerkleProofVerifyOnlyRootAndLeaf(uint256 root, uint256 leaf) external {
        MerkleWords merkleWords = new MerkleWords();

        checkUnhappyParse2(
            bytes(
                string.concat(
                    "using-words-from ",
                    address(merkleWords).toHexString(),
                    "\n",
                    "root: ",
                    root.toHexString(),
                    ",",
                    "leaf: ",
                    leaf.toHexString(),
                    ",",
                    " _: merkle-proof-verify(root leaf);"
                )
            ),
            abi.encodeWithSelector(ExternIntegrityInputsMismatch.selector, 2, 3)
        );
    }
}
