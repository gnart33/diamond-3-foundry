// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DummyFacet {
    event DummyEvent(address something);

    function dummyFunc1() external {}

    function dummyFunc2() external {}

    function dummyFunc3() external {}

    function supportsInterface(bytes4 _interfaceID) external view returns (bool) {}
}
