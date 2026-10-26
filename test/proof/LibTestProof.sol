// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {Test} from "forge-std-1.17.0/src/Test.sol";

bytes32 constant ROOT = 0xd4dee0beab2d53f2cc83e567171bd2820e49898130a22622b10ead383e90bd77;
bytes32 constant PROOF0_0 = 0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc;

address constant LEAF0_0_VALUE = 0x1111111111111111111111111111111111111111;
bytes32 constant LEAF0_0_AMOUNT = bytes32(uint256(5000000000000000000));
bytes32 constant LEAF0_0_INNER = 0x1fec8b8a5a8c4018915544987a63932a69dc9c26bddbc32b1b60dd3f9a6201e5;
bytes32 constant LEAF0_0 = 0xeb02c421cfa48976e66dfb29120745909ea3a0f843456c263cf8f1253483e283;

address constant LEAF1_0_VALUE = 0x2222222222222222222222222222222222222222;
bytes32 constant LEAF1_0_AMOUNT = bytes32(uint256(2500000000000000000));
bytes32 constant LEAF1_0_INNER = 0x34e7d9283570da46fe6ee63f86208d24bdba0621148d9e104898449f0406625f;
bytes32 constant LEAF1_0 = 0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc;

bytes32 constant PROOF1_0 = 0xeb02c421cfa48976e66dfb29120745909ea3a0f843456c263cf8f1253483e283;

contract TestProofTest is Test {
    function testDerivedConstants() external pure {
        assertEq(LEAF0_0_INNER, keccak256(abi.encode(LEAF0_0_VALUE, LEAF0_0_AMOUNT)), "LEAF0_0_INNER");
        assertEq(LEAF0_0, keccak256(bytes.concat(LEAF0_0_INNER)), "LEAF0_0 should match the calculated value");
        assertEq(PROOF0_0, LEAF1_0, "PROOF0_0 should match LEAF1_0");

        assertEq(LEAF1_0_INNER, keccak256(abi.encode(LEAF1_0_VALUE, LEAF1_0_AMOUNT)), "LEAF1_0_INNER");
        assertEq(LEAF1_0, keccak256(bytes.concat(LEAF1_0_INNER)), "LEAF1_0 should match the calculated value");
        assertEq(PROOF1_0, LEAF0_0, "PROOF1_0 should match LEAF0_0");
    }

    function testTreeConstants() external view {
        // forge-lint: disable-next-line(unsafe-cheatcode)
        string memory tree = vm.readFile("test/proof/tree.json");
        bytes memory rootBytes = vm.parseJson(tree, ".tree[0]");
        bytes32 root = abi.decode(rootBytes, (bytes32));

        assertEq(ROOT, root, "ROOT should match the value in the tree.json file");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory proof0_0Bytes = vm.parseJson(tree, ".tree[2]");
        // forge-lint: disable-next-line(mixed-case-variable)
        bytes32 proof0_0 = abi.decode(proof0_0Bytes, (bytes32));

        assertEq(PROOF0_0, proof0_0, "PROOF0_0 should match the value in the tree.json file");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory proof1_0Bytes = vm.parseJson(tree, ".tree[1]");
        // forge-lint: disable-next-line(mixed-case-variable)
        bytes32 proof1_0 = abi.decode(proof1_0Bytes, (bytes32));

        assertEq(PROOF1_0, proof1_0, "PROOF1_0 should match the value in the tree.json file");
    }

    function testLeafConstants() external view {
        // forge-lint: disable-next-line(unsafe-cheatcode)
        string memory tree = vm.readFile("test/proof/tree.json");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory leaf0_0ValueBytes = vm.parseJson(tree, ".values[0].value[0]");
        // forge-lint: disable-next-line(mixed-case-variable)
        address leaf0_0Value = abi.decode(leaf0_0ValueBytes, (address));

        assertEq(LEAF0_0_VALUE, leaf0_0Value, "LEAF0_0_VALUE should match the value in the tree.json file");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory leaf0_0AmountBytes = vm.parseJson(tree, ".values[0].value[1]");
        // forge-lint: disable-next-line(mixed-case-variable)
        string memory leaf0_0AmountString = abi.decode(leaf0_0AmountBytes, (string));
        // forge-lint: disable-next-line(mixed-case-variable)
        bytes32 leaf0_0Amount = bytes32(vm.parseUint(leaf0_0AmountString));
        assertEq(LEAF0_0_AMOUNT, leaf0_0Amount, "LEAF0_0_AMOUNT should match the value in the tree.json file");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory leaf1_0ValueBytes = vm.parseJson(tree, ".values[1].value[0]");
        // forge-lint: disable-next-line(mixed-case-variable)
        address leaf1_0Value = abi.decode(leaf1_0ValueBytes, (address));
        assertEq(LEAF1_0_VALUE, leaf1_0Value, "LEAF1_0_VALUE should match the value in the tree.json file");

        // forge-lint: disable-next-line(mixed-case-variable)
        bytes memory leaf1_0AmountBytes = vm.parseJson(tree, ".values[1].value[1]");
        // forge-lint: disable-next-line(mixed-case-variable)
        string memory leaf1_0AmountString = abi.decode(leaf1_0AmountBytes, (string));
        // forge-lint: disable-next-line(mixed-case-variable)
        bytes32 leaf1_0Amount = bytes32(vm.parseUint(leaf1_0AmountString));
        assertEq(LEAF1_0_AMOUNT, leaf1_0Amount, "LEAF1_0_AMOUNT should match the value in the tree.json file");
    }
}
