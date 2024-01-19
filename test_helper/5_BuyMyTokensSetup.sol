// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { BuyMyTokens } from "../src/5_BuyMyTokens.sol";
import "../mocks/marqToken.sol";
import "forge-std/Test.sol";

contract BuyMyTokensHelper is Test {

    BuyMyTokens public deployed;
    address public tokenAddress1;
    address public tokenAddress2;
    address public tokenAddress3;
    MarqToken public token1;
    MarqToken public token2;
    MarqToken public token3;

    constructor() {
        MarqToken token1 = new MarqToken();
        tokenAddress1 = address(token1);
        MarqToken token2 = new MarqToken();
        tokenAddress2 = address(token2);
        MarqToken token3 = new MarqToken();
        tokenAddress3 = address(token3);
        deployed = new BuyMyTokens(tokenAddress1, tokenAddress2, tokenAddress3);




        token1.mint(1000 ether);
        token1.transfer(address(deployed), 1000 ether);
        token2.mint(1000 ether);
        token2.transfer(address(deployed), 1000 ether);
        token3.mint(1000 ether);
        token3.transfer(address(deployed), 1000 ether);

        vm.deal(address(0xBAD), 1.2 ether);
    }

}


