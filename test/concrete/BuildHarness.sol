// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {Build, GeneratedContract} from "script/Build.sol";
import {DeployCandidate} from "rain-deploy-0.1.33/src/abstract/RainDeploySuitesBase.sol";

/// @title BuildHarness
/// @notice External seam onto `Build`'s internal declarations.
contract BuildHarness is Build {
    function externalGeneratedContracts() external pure returns (GeneratedContract[] memory) {
        return generatedContracts(declaration());
    }

    function externalSnapshotContractNames() external pure returns (string[] memory) {
        return snapshotContractNames(generatedContracts(declaration()));
    }

    function externalCandidateSuites() external pure returns (DeployCandidate[] memory) {
        return checkedCandidateSuites(declaration());
    }
}
