// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {RainDeployVerifyChain} from "rain-deploy-0.1.22/src/abstract/RainDeployVerifyChain.sol";
import {MerkleWordsDeploySuites} from "src/abstract/MerkleWordsDeploySuites.sol";

/// @title MerkleWordsDeployChainTest
/// @notice Every released `MerkleWords` suite is live on every supported network.
contract MerkleWordsDeployChainTest is MerkleWordsDeploySuites, RainDeployVerifyChain {}
