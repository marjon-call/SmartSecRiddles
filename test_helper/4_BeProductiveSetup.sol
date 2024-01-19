// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { BeProductive } from "../src/4_BeProductive.sol";
import "../mocks/marqToken.sol";
import "forge-std/Test.sol";

contract BeProductiveHelper is Test {

    BeProductive public deployed;
    address public tokenAddress;
    MarqToken public token;

    constructor() {
        MarqToken token = new MarqToken();
        tokenAddress = address(token);
        deployed = new BeProductive(address(token));




        token.mint(600 ether);
        token.transfer(address(0xBAD), 10 ether);
        token.transfer(address(deployed), 590 ether);
    }

}