// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {Test} from "forge-std-1.17.0/src/Test.sol";
import {DeployCandidate} from "rain-deploy-0.1.22/src/abstract/RainDeploySuitesBase.sol";
import {MerkleWordsDeploySuites} from "src/abstract/MerkleWordsDeploySuites.sol";
import {MerkleWords} from "src/concrete/MerkleWords.sol";

/// @title MerkleWordsDeploySuitesTest
/// @notice The candidate fields the verify abstracts do not constrain.
contract MerkleWordsDeploySuitesTest is MerkleWordsDeploySuites, Test {
    /// Restated because the dispatching workflow is outside the EVM.
    function testMerkleWordsSuiteKeyIsTheDispatchedSuite() external pure {
        DeployCandidate memory candidate = merkleWordsCandidate();
        assertEq(candidate.snapshot.suite, "merkle-words", "suite key is not what the deploy workflow dispatches");
    }

    function testMerkleWordsArtifactPathIsTheCandidateContract() external view {
        DeployCandidate memory candidate = merkleWordsCandidate();
        assertEq(
            keccak256(vm.getCode(candidate.snapshot.artifactPath)),
            keccak256(type(MerkleWords).creationCode),
            "artifact path does not compile to MerkleWords"
        );
    }

    function testMerkleWordsCandidateHasNoDependencies() external pure {
        DeployCandidate memory candidate = merkleWordsCandidate();
        assertEq(candidate.snapshot.dependencies.length, 0, "candidate declares a construction dependency");
    }
}
