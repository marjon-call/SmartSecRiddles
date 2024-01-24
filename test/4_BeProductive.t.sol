// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { BeProductive } from "../src/4_BeProductive.sol";
import { BeProductiveHelper } from "../test_helper/4_BeProductiveSetup.sol";
import "../mocks/marqToken.sol";


contract BeProductiveTest is Test {
    BeProductive public target;
    MarqToken public token;


    struct ProgressTracker {
        uint256 saved;
        uint256 target;
    }


    function setUp() public {
        BeProductiveHelper dontpeak = new BeProductiveHelper();
        target = dontpeak.deployed();
        token = MarqToken(dontpeak.tokenAddress());
    }


 
    function test_GetThisPassing_4() public {
        address hacker = address(0xBAD);
        
        vm.startPrank(hacker);
        
        vm.stopPrank();

        assertGt(token.balanceOf(hacker), 700 ether);
    }

}