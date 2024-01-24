// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { BuyMyTokens } from "../src/5_BuyMyTokens.sol";
import { BuyMyTokensHelper } from "../test_helper/5_BuyMyTokensSetup.sol";
import "../mocks/marqToken.sol";


contract BuyMyTokensTest is Test {
    BuyMyTokens public target;
    MarqToken public token1;
    MarqToken public token2;
    MarqToken public token3;


    function setUp() public {
        BuyMyTokensHelper dontpeak = new BuyMyTokensHelper();
        target = dontpeak.deployed();
        token1 = MarqToken(dontpeak.tokenAddress1());
        token2 = MarqToken(dontpeak.tokenAddress2());
        token3 = MarqToken(dontpeak.tokenAddress3());
    }


 
    function test_GetThisPassing_5() public {
        address hacker = address(0xBAD);
        

        vm.startPrank(hacker);
        
        vm.stopPrank();

        assertEq(token1.balanceOf(hacker), 12 ether);
        assertEq(token2.balanceOf(hacker), 6 ether);
        assertEq(token3.balanceOf(hacker), 4 ether);
    }

}


