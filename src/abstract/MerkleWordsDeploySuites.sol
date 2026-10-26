// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {
    DeployCandidate,
    DeployDependency,
    DeployMechanism,
    DeploySuite,
    RainDeploySuitesBase
} from "rain-deploy-0.1.22/src/abstract/RainDeploySuitesBase.sol";
import {
    CREATION_CODE as MERKLE_WORDS_CREATION_CODE_CANDIDATE,
    RUNTIME_CODE as MERKLE_WORDS_RUNTIME_CODE_CANDIDATE
} from "../generated/candidate/MerkleWords.sol";
import {LibMerkleWordsDeploy} from "../lib/LibMerkleWordsDeploy.sol";
import {LibReleasedSuites} from "../lib/LibReleasedSuites.sol";

/// @title MerkleWordsDeploySuites
/// @notice Everything this repo deploys, declared once. In `src/` because the
/// published package excludes `test/`.
abstract contract MerkleWordsDeploySuites is RainDeploySuitesBase {
    /// @inheritdoc RainDeploySuitesBase
    function releasedSuites() internal pure override returns (DeploySuite[] memory) {
        return LibReleasedSuites.releasedSuites();
    }

    /// @inheritdoc RainDeploySuitesBase
    function candidateSuites() internal pure override returns (DeployCandidate[] memory) {
        DeployCandidate[] memory candidates = new DeployCandidate[](1);
        candidates[0] = merkleWordsCandidate();
        return candidates;
    }

    /// Named so `script/Build.sol` emits the released-suites lib from this
    /// candidate without indexing into `candidateSuites`.
    /// @return The candidate.
    function merkleWordsCandidate() internal pure returns (DeployCandidate memory) {
        return DeployCandidate({
            snapshot: DeploySuite({
                suite: "merkle-words",
                creationCode: MERKLE_WORDS_CREATION_CODE_CANDIDATE,
                storedDeployedAddress: LibMerkleWordsDeploy.MERKLE_WORDS_DEPLOYED_ADDRESS,
                storedBytecodeHash: LibMerkleWordsDeploy.MERKLE_WORDS_DEPLOYED_CODEHASH,
                storedRuntimeCode: MERKLE_WORDS_RUNTIME_CODE_CANDIDATE,
                artifactPath: "src/concrete/MerkleWords.sol:MerkleWords",
                dependencies: new DeployDependency[](0),
                mechanism: DeployMechanism.Zoltu,
                mechanismData: ""
            }),
            unanchorableReason: ""
        });
    }
}
