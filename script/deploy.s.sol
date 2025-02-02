// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {Diamond} from "../contracts/Diamond.sol";
import {DiamondCutFacet} from "../contracts/facets/DiamondCutFacet.sol";
import {OwnershipFacet} from "../contracts/facets/OwnershipFacet.sol";

contract DeployDiamond is Script {
    Diamond public diamond;
    DiamondCutFacet public diamondCutFacet;
    OwnershipFacet public ownershipFacet;

    function run() public {
        vm.startBroadcast();

        // Deploy the core facets needed for diamond functionality
        diamondCutFacet = new DiamondCutFacet(); // Handles adding/replacing/removing facets
        ownershipFacet = new OwnershipFacet(); // Handles ownership management

        vm.stopBroadcast();
    }
}
