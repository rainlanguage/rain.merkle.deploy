// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {Vm} from "forge-std-1.17.0/src/Vm.sol";

/// @title LibReleasedSuitesAggregate
/// @notice Reads back which contracts a generated released-suites aggregate
/// imports, in order.
library LibReleasedSuitesAggregate {
    function declaredContractNames(Vm vm, string memory source) internal pure returns (string[] memory) {
        string[] memory chunks = vm.split(source, "\nimport {Lib");

        uint256 count = 0;
        for (uint256 i = 1; i < chunks.length; i++) {
            if (vm.split(chunks[i], "Released}").length > 1) {
                count++;
            }
        }

        string[] memory names = new string[](count);
        uint256 j = 0;
        for (uint256 i = 1; i < chunks.length; i++) {
            string[] memory parts = vm.split(chunks[i], "Released}");
            if (parts.length > 1) {
                names[j++] = parts[0];
            }
        }
        return names;
    }
}
