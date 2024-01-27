// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { FuzzThis } from "../src/1_FuzzThis.sol";
import { FuzzThisHelper } from "../test_helper/1_FuzzThisSetup.sol";

contract FuzzTest is Test {
    FuzzThis public target;

    function setUp() public {
        FuzzThisHelper dontpeak = new FuzzThisHelper();
        target = dontpeak.deployed();
    }


    function test_GetThisFailing_1(uint256 _guess) public {

        vm.assume(_guess < 5000);
        bytes memory solution = "loss";


        bytes memory answer = bytes("Replace this with your solution");

        assertEq(solution, answer);
    }

}
