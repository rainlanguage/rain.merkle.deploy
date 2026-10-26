// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {RainDeployBroadcast} from "rain-deploy-0.1.22/src/abstract/RainDeployBroadcast.sol";
import {MerkleWordsDeploySuites} from "../src/abstract/MerkleWordsDeploySuites.sol";

/// @title Deploy
/// @notice Broadcasts the suite `DEPLOYMENT_SUITE` names.
contract Deploy is MerkleWordsDeploySuites, RainDeployBroadcast {}
