// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

/// @title LibStringSet
/// @notice Membership over a `string[]`.
library LibStringSet {
    function holds(string[] memory haystack, string memory needle) internal pure returns (bool) {
        for (uint256 i = 0; i < haystack.length; i++) {
            if (keccak256(bytes(haystack[i])) == keccak256(bytes(needle))) {
                return true;
            }
        }
        return false;
    }
}
