// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Staking, Rewarder } from "../src/6_NotForTrusting.sol";
import "../mocks/marqToken.sol";
import "../mocks/NFT.sol";
import "forge-std/Test.sol";


contract NotForTrustingHelper is Test {

    Staking public deployed1;
    Rewarder public deployed2;
    address public tokenAddress;
    address public nftAddress;
    MarqToken public token;
    NFT public nft;


    constructor() {
        MarqToken token = new MarqToken();
        tokenAddress = address(token);
        NFT nft = new NFT();
        nftAddress = address(nft);
        deployed2 = new Rewarder(tokenAddress, 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
        deployed1 = new Staking(nftAddress, address(deployed2));

        vm.prank(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38);
        deployed2.setStaker(address(deployed1));

        nft.mint(address(0xBAD));        

    }

}


