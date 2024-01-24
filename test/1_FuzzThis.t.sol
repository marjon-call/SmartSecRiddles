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




        assertEq(solution, answer);
    }


    // solution
    function test_GetThisFailing_1(uint256 _guess) public {

        vm.assume(_guess < 5000);
        bytes memory solution = "loss";



        bytes32 guess = keccak256(abi.encode(15 + _guess));


        bytes memory answer = target.dontHackMePlease(guess);


        assertEq(solution, answer);
    }

}
