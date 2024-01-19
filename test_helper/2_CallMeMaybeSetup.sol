// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import { CallMeMaybe } from "../src/2_CallMeMaybe.sol";
import "../mocks/marqToken.sol";

contract CallMeMaybeHelper is Test {

    CallMeMaybe public deployed;
    MarqToken public token;

    address[] public users = [address(0x01), address(0x02), address(0x03)];

    constructor() {
        token = new MarqToken();
        deployed = new CallMeMaybe(address(token));

        token.mint(601 ether);
        
        token.transfer(address(0xBAD), 1 ether);

        for (uint256 i; i < users.length; ++i) {
            address user = users[i];
            token.transfer(user, 200 ether);
            vm.startPrank(user);
            token.approve(address(deployed), type(uint256).max);
            deployed.joinGroup(100 ether);
            vm.stopPrank();
        }


    }

}