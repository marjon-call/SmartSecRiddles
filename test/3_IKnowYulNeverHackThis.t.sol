// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { IKnowYulNeverHackThis } from "../src/3_IKnowYulNeverHackThis.sol";
import { IKnowYulNeverHackThisHelper } from "../test_helper/3_IKnowYulNeverHackThisSetup.sol";


contract IKnowYulNeverHackThisTest is Test {
    IKnowYulNeverHackThis public target;


    function setUp() public {
        IKnowYulNeverHackThisHelper dontpeak = new IKnowYulNeverHackThisHelper();
        target = dontpeak.deployed();
    }


    function test_GetThisPassing_3(uint256 _guess) public {
        address hacker = address(0xBAD);
        vm.deal(hacker, 1 ether);

        vm.startPrank(hacker);
        
        vm.stopPrank();
        
        assertEq(hacker.balance, 10 ether);
    }

}