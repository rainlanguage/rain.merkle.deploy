// SPDX-License-Identifier: LicenseRef-DCL-1.0
// SPDX-FileCopyrightText: Copyright (c) 2020 Rain Open Source Software Ltd
pragma solidity =0.8.25;

import {BuildScript} from "rain-deploy-0.1.25/src/abstract/BuildScript.sol";
import {DeployCandidate} from "rain-deploy-0.1.25/src/abstract/RainDeploySuitesBase.sol";
import {LibRainDeploy} from "rain-deploy-0.1.25/src/lib/LibRainDeploy.sol";
import {LibRainDeploySnapshot} from "rain-deploy-0.1.25/src/lib/LibRainDeploySnapshot.sol";
import {LibFs} from "rain-sol-codegen-0.1.39/src/lib/LibFs.sol";
import {LibCodeGen} from "rain-sol-codegen-0.1.39/src/lib/LibCodeGen.sol";
import {LibGenParseMeta} from "rainlang-0.2.27/src/lib/codegen/LibGenParseMeta.sol";
import {MerkleWordsDeploySuites} from "../src/abstract/MerkleWordsDeploySuites.sol";
import {MerkleWords} from "../src/concrete/MerkleWords.sol";
import {LibMerkleSubParser} from "../src/lib/parse/LibMerkleSubParser.sol";
import {PARSE_META_BUILD_DEPTH} from "../src/abstract/MerkleSubParser.sol";

/// One contract's generated snapshot, alias lib and released-suites lib.
struct GeneratedContract {
    string contractName;
    string constantPrefix;
    DeployCandidate candidate;
}

/// @title Build
/// @notice Generates the deploy pins and the function pointers for every
/// contract this repo deploys.
contract Build is BuildScript, MerkleWordsDeploySuites {
    function generatedContracts() internal pure returns (GeneratedContract[] memory) {
        GeneratedContract[] memory contracts = new GeneratedContract[](1);
        contracts[0] = GeneratedContract({
            contractName: "MerkleWords", constantPrefix: "MERKLE_WORDS", candidate: merkleWordsCandidate()
        });
        return contracts;
    }

    function snapshotContractNames() internal pure override returns (string[] memory) {
        GeneratedContract[] memory contracts = generatedContracts();
        string[] memory names = new string[](contracts.length);
        for (uint256 i = 0; i < contracts.length; i++) {
            names[i] = contracts[i].contractName;
        }
        return names;
    }

    function regenerateLibs() internal override {
        GeneratedContract[] memory contracts = generatedContracts();
        for (uint256 i = 0; i < contracts.length; i++) {
            LibRainDeploySnapshot.writeAliasLib(
                vm,
                LibRainDeploySnapshot.LIB_DIR,
                contracts[i].contractName,
                contracts[i].constantPrefix,
                LibRainDeploySnapshot.CANDIDATE
            );
            LibRainDeploySnapshot.writeReleasedSuitesLib(
                vm,
                LibRainDeploySnapshot.LIB_DIR,
                recordRoot(),
                contracts[i].contractName,
                contracts[i].candidate.snapshot
            );
        }
        LibRainDeploySnapshot.writeReleasedSuitesAggregate(vm, LibRainDeploySnapshot.LIB_DIR, snapshotContractNames());
    }

    function regenerateSnapshots() internal override {
        GeneratedContract[] memory contracts = generatedContracts();
        for (uint256 i = 0; i < contracts.length; i++) {
            LibRainDeploySnapshot.writeSnapshot(
                vm,
                recordRoot(),
                LibRainDeploySnapshot.CANDIDATE,
                contracts[i].contractName,
                vm.getCode(contracts[i].candidate.snapshot.artifactPath),
                contracts[i].candidate.snapshot.dependencies
            );
        }
        buildMerkleWordsPointers();
    }

    /// Read from the instance `writeSnapshot` already deployed through the
    /// Zoltu factory, so the pointers and the snapshot come from one compile.
    function buildMerkleWordsPointers() internal {
        MerkleWords merkleWords = MerkleWords(LibRainDeploy.zoltuAddress(type(MerkleWords).creationCode));

        LibFs.buildFileForContract(
            vm,
            address(merkleWords),
            "MerkleWordsPointers",
            string.concat(
                LibCodeGen.describedByMetaHashConstantString(vm, "MerkleWords"),
                LibGenParseMeta.parseMetaConstantString(
                    vm, LibMerkleSubParser.authoringMetaV2(), PARSE_META_BUILD_DEPTH
                ),
                LibCodeGen.subParserWordParsersConstantString(vm, merkleWords),
                LibCodeGen.operandHandlerFunctionPointersConstantString(vm, merkleWords),
                LibCodeGen.integrityFunctionPointersConstantString(vm, merkleWords),
                LibCodeGen.opcodeFunctionPointersConstantString(vm, merkleWords)
            )
        );
    }
}
