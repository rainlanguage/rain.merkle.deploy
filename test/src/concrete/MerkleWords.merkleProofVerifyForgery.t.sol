// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {MerkleWords} from "src/concrete/MerkleWords.sol";
import {OpTest, StackItem} from "rainlang-0.2.19/test/abstract/OpTest.sol";
import {Hashes} from "@openzeppelin-contracts-5.7.0/utils/cryptography/Hashes.sol";
import {Strings} from "@openzeppelin-contracts-5.7.0/utils/Strings.sol";

contract MerkleWordsMerkleProofVerifyForgeryTest is OpTest {
    using Strings for address;
    using Strings for uint256;

    MerkleWords internal merkleWords;
    bytes32 internal l0;
    bytes32 internal l1;
    bytes32 internal l2;
    bytes32 internal l3;
    bytes32 internal n01;
    bytes32 internal n23;
    bytes32 internal root;

    function account(uint256 i) internal pure returns (address) {
        return address(uint160(i + 1));
    }

    function amount(uint256 i) internal pure returns (uint256) {
        return i * 1e18;
    }

    function standardLeaf(uint256 i) internal pure returns (bytes32) {
        return keccak256(bytes.concat(keccak256(abi.encode(account(i), amount(i)))));
    }

    function setUp() public {
        merkleWords = new MerkleWords();
        l0 = standardLeaf(0);
        l1 = standardLeaf(1);
        l2 = standardLeaf(2);
        l3 = standardLeaf(3);
        n01 = Hashes.commutativeKeccak256(l0, l1);
        n23 = Hashes.commutativeKeccak256(l2, l3);
        root = Hashes.commutativeKeccak256(n01, n23);
    }

    function h(bytes32 x) internal pure returns (string memory) {
        return uint256(x).toHexString();
    }

    function hashedValues(uint256 i) internal pure returns (string memory) {
        return string.concat("hash(", account(i).toHexString(), " ", amount(i).toHexString(), ")");
    }

    function evalTop(string memory body) internal view returns (bytes32) {
        (StackItem[] memory stack,) =
            parseAndEval(bytes(string.concat("using-words-from ", address(merkleWords).toHexString(), "\n", body)));
        return StackItem.unwrap(stack[0]);
    }

    function testStandardLeafVerifiesWithTwoElementProof() external view {
        assertEq(
            evalTop(
                string.concat("_: merkle-proof-verify(", h(root), " ", hashedValues(0), " ", h(l1), " ", h(n23), ");")
            ),
            bytes32(uint256(1))
        );
        assertEq(
            evalTop(
                string.concat("_: merkle-proof-verify(", h(root), " ", hashedValues(0), " ", h(n23), " ", h(l1), ");")
            ),
            0
        );
    }

    function testInternalNodeRejectedAsLeaf() external view {
        assertEq(evalTop(string.concat("_: merkle-proof-verify(", h(root), " ", h(n01), " ", h(n23), ");")), 0);
    }

    function testSingleHashedInternalNodePreimageRejected() external view {
        (bytes32 a, bytes32 b) = l0 < l1 ? (l0, l1) : (l1, l0);
        assertEq(
            evalTop(string.concat("_: merkle-proof-verify(", h(root), " hash(", h(a), " ", h(b), ") ", h(n23), ");")), 0
        );
    }

    function testSingleHashedTreeLeafRejected() external view {
        bytes32 s0 = keccak256(abi.encode(account(0), amount(0)));
        bytes32 s1 = keccak256(abi.encode(account(1), amount(1)));
        bytes32 simpleRoot = Hashes.commutativeKeccak256(s0, s1);
        assertEq(
            evalTop(string.concat("_: merkle-proof-verify(", h(simpleRoot), " ", hashedValues(0), " ", h(s1), ");")), 0
        );
    }
}
