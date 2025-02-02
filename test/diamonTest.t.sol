// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {DeployDiamond} from "../script/deploy.s.sol";

contract DiamondTest is Test {
    DeployDiamond public deployDiamond;

    // function setUp() public {
    //     deployDiamond = new DeployDiamond();
    // }

    function test_deployDiamond() public {
        deployDiamond = new DeployDiamond();
        deployDiamond.run();
    }
}
