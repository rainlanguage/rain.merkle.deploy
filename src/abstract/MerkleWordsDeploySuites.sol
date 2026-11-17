// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity ^0.8.25;

import {
    DeployCandidate,
    DeployDeclaration,
    DeployDependency,
    DeploySuite,
    ExternalDeployment,
    RainDeploySuitesBase
} from "rain-deploy-0.1.33/src/abstract/RainDeploySuitesBase.sol";
import {LibRainDeployDeclaration} from "rain-deploy-0.1.33/src/lib/LibRainDeployDeclaration.sol";
import {LibRainDeployZoltuMechanism} from "rain-deploy-0.1.33/src/lib/LibRainDeployZoltuMechanism.sol";
import {
    CREATION_CODE as MERKLE_WORDS_CREATION_CODE_CANDIDATE,
    RUNTIME_CODE as MERKLE_WORDS_RUNTIME_CODE_CANDIDATE
} from "../generated/candidate/MerkleWords.sol";
import {LibMerkleWordsDeploy} from "../lib/LibMerkleWordsDeploy.sol";
import {LibReleasedSuites} from "../lib/LibReleasedSuites.sol";
import {MerkleWords} from "../concrete/MerkleWords.sol";

string constant MERKLE_WORDS_SUITE = "merkle-words";

/// @title MerkleWordsDeploySuites
/// @notice Everything this repo deploys, declared once. In `src/` because the
/// published package excludes `test/`.
abstract contract MerkleWordsDeploySuites is RainDeploySuitesBase {
    /// @inheritdoc RainDeploySuitesBase
    function declaration() internal pure override returns (DeployDeclaration memory) {
        DeployDeclaration memory declared;
        LibRainDeployDeclaration.extend(declared);
        LibRainDeployZoltuMechanism.extend(declared);
        LibRainDeployDeclaration.addReleased(declared, LibReleasedSuites.releasedSuites());
        DeployCandidate[] memory candidates = new DeployCandidate[](1);
        candidates[0] = merkleWordsCandidate();
        LibRainDeployDeclaration.addCandidates(declared, candidates);
        declared.sourceCreationCode = sourceCreationCode;
        declared.externalDeployments = externalDeployments();
        return declared;
    }

    function sourceCreationCode(string memory suite) internal pure returns (bytes memory) {
        if (keccak256(bytes(suite)) == keccak256(bytes(MERKLE_WORDS_SUITE))) {
            return type(MerkleWords).creationCode;
        }
        revert(string.concat("no source for suite: ", suite));
    }

    function externalDeployments() internal pure returns (ExternalDeployment[] memory) {
        return new ExternalDeployment[](0);
    }

    /// Named so `script/Build.sol` emits the released-suites lib from this
    /// candidate without indexing into `declaration().candidates`.
    /// @return The candidate.
    function merkleWordsCandidate() internal pure returns (DeployCandidate memory) {
        return DeployCandidate({
            snapshot: DeploySuite({
                suite: MERKLE_WORDS_SUITE,
                creationCode: MERKLE_WORDS_CREATION_CODE_CANDIDATE,
                storedDeployedAddress: LibMerkleWordsDeploy.MERKLE_WORDS_DEPLOYED_ADDRESS,
                storedBytecodeHash: LibMerkleWordsDeploy.MERKLE_WORDS_DEPLOYED_CODEHASH,
                storedRuntimeCode: MERKLE_WORDS_RUNTIME_CODE_CANDIDATE,
                artifactPath: "src/concrete/MerkleWords.sol:MerkleWords",
                dependencies: new DeployDependency[](0),
                mechanismData: LibRainDeployZoltuMechanism.mechanismData(),
                networks: new string[](0),
                describedByMeta: ""
            }),
            unanchorableReason: ""
        });
    }
}
