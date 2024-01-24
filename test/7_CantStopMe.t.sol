// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { Test, console } from "forge-std/Test.sol";
import { TrustyOracle, Auction } from "../src/7_CantStopMe.sol";
import { CantStopMeHelper } from "../test_helper/7_CantStopMeSetup.sol";
import "../mocks/NFT.sol";


contract CantStopMe is Test {
    CantStopMeHelper public dontpeak;
    Auction public auction;
    TrustyOracle public oracle;
    NFT public nft;


    function setUp() public {
        dontpeak = new CantStopMeHelper();
        auction = dontpeak.deployed1();
        oracle = dontpeak.deployed2();
        nft = NFT(dontpeak.nftAddress());
    }

    function test_GetThisPassing_7() public {

        address hacker = address(0xBAD);

        vm.startPrank(hacker);
        
        vm.stopPrank();

        dontpeak.checkIfPasses();
    }

}