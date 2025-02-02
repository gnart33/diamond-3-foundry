// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
// import {DeployDiamond} from "../script/deploy.s.sol";
import {DiamondCutFacet} from "../contracts/facets/DiamondCutFacet.sol";
import {OwnershipFacet} from "../contracts/facets/OwnershipFacet.sol";
import {LibDiamond} from "../contracts/libraries/LibDiamond.sol";
import {Diamond} from "../contracts/Diamond.sol";
import {IDiamondCut} from "../contracts/interfaces/IDiamondCut.sol";
import {DiamondLoupeFacet} from "../contracts/facets/DiamondLoupeFacet.sol";

contract DiamondTest is Test {
    // DeployDiamond public deployDiamond;
    DiamondCutFacet public diamondCutFacet;
    OwnershipFacet public ownershipFacet;
    Diamond public diamond;
    DiamondLoupeFacet public diamondLoupeFacet;
    address public diamondOwner;
    address[] public facets;

    // Diamond public diamond;
    function setUp() public {
        // deployDiamond = new DeployDiamond();
        diamondOwner = address(123456);

        diamondCutFacet = new DiamondCutFacet();
        // diamondLoupeFacet = new DiamondLoupeFacet();
        ownershipFacet = new OwnershipFacet();

        diamond = new Diamond(address(diamondOwner), address(diamondCutFacet));
    }

    function test_diamondLoupeFacet() public {
        diamondLoupeFacet = new DiamondLoupeFacet();

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);

        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });
        diamondCutFacet.diamondCut(cut, address(0), "");

        facets = diamondLoupeFacet.facetAddresses();
        console2.log("Facets: ", facets.length);
    }
}
