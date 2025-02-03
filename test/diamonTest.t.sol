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

    function setUp() public {
        diamondOwner = address(123456);
        diamondCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(diamondOwner), address(diamondCutFacet));
        addDiamondLoupeFacet();
        addOwnershipFacet();
    }

    function addDiamondLoupeFacet() public {
        // add diamondLoupeFacet to diamond

        diamondLoupeFacet = new DiamondLoupeFacet();
        // prepare function selectors
        bytes4[] memory functionSelectors = new bytes4[](4);
        functionSelectors[0] = diamondLoupeFacet.facets.selector;
        functionSelectors[1] = diamondLoupeFacet.facetFunctionSelectors.selector;
        functionSelectors[2] = diamondLoupeFacet.facetAddresses.selector;
        functionSelectors[3] = diamondLoupeFacet.facetAddress.selector;

        // prepare diamondCut
        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(diamondLoupeFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });

        // add diamondLoupeFacet to diamond
        vm.prank(address(diamondOwner));
        DiamondCutFacet(address(diamond)).diamondCut(cuts, address(0), "");
        vm.stopPrank();
    }

    function addOwnershipFacet() public {
        // add diamondLoupeFacet to diamond

        ownershipFacet = new OwnershipFacet();
        // prepare function selectors
        bytes4[] memory functionSelectors = new bytes4[](2);
        functionSelectors[0] = ownershipFacet.transferOwnership.selector;
        functionSelectors[1] = ownershipFacet.owner.selector;

        // prepare diamondCut
        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: address(ownershipFacet),
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });

        // add diamondLoupeFacet to diamond
        vm.prank(address(diamondOwner));
        DiamondCutFacet(address(diamond)).diamondCut(cuts, address(0), "");
        vm.stopPrank();
    }

    function test_numberOfFacets() public view {
        address[] memory facets = DiamondLoupeFacet(address(diamond)).facetAddresses();
        assertEq(facets.length, 3, "Should have 3 facets");
        assertEq(facets[0], address(diamondCutFacet), "First facet is not diamondCutFacet");
        assertEq(facets[1], address(diamondLoupeFacet), "Second facet is not diamondLoupeFacet");
        assertEq(facets[2], address(ownershipFacet), "Third facet is not ownershipFacet");
    }

    function test_facetAddress() public view {
        // facet address of a function selector should be  associated to facets correctly multiple calls to facetAddress function
        bytes4 selector = diamondCutFacet.diamondCut.selector; // function selector of diamondCutFacet.diamondCut
        assertEq(DiamondLoupeFacet(address(diamond)).facetAddress(selector), address(diamondCutFacet), "First facet address is not diamondCutFacet");
    }

    function test_facetFunctionSelectors() public view {
        // facets should have the right function selectors -- call to facetFunctionSelectors function
        bytes4[] memory selectors;

        selectors = DiamondLoupeFacet(address(diamond)).facetFunctionSelectors(address(diamondCutFacet));
        assertEq(selectors.length, 1, "Should have 1 selector for diamondCutFacet");
        assertEq(selectors[0], diamondCutFacet.diamondCut.selector, "First selector is not diamondCutFacet.diamondCut");

        selectors = DiamondLoupeFacet(address(diamond)).facetFunctionSelectors(address(diamondLoupeFacet));
        assertEq(selectors.length, 4, "Should have 4 selectors for diamondLoupeFacet");
        assertEq(selectors[0], diamondLoupeFacet.facets.selector, "Second selector is not diamondLoupeFacet.facets");
        assertEq(selectors[1], diamondLoupeFacet.facetFunctionSelectors.selector, "Third selector is not diamondLoupeFacet.facetFunctionSelectors");
        assertEq(selectors[2], diamondLoupeFacet.facetAddresses.selector, "Fourth selector is not diamondLoupeFacet.facetAddresses");
        assertEq(selectors[3], diamondLoupeFacet.facetAddress.selector, "Fifth selector is not diamondLoupeFacet.facetAddress");

        selectors = DiamondLoupeFacet(address(diamond)).facetFunctionSelectors(address(ownershipFacet));
        assertEq(selectors.length, 2, "Should have 2 selectors for ownershipFacet");
        assertEq(selectors[0], ownershipFacet.transferOwnership.selector, "Second selector is not ownershipFacet.transferOwnership");
        assertEq(selectors[1], ownershipFacet.owner.selector, "Third selector is not ownershipFacet.owner");
    }
}
