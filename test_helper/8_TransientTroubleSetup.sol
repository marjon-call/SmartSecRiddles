// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { ExclusiveClub } from "../src/8_TransientTrouble.sol";
import "../mocks/NFT.sol";
import "forge-std/Test.sol";


contract TransientTroubleHelper is Test {

    ExclusiveClub public deployed;
    NFT public ticket;
    address nftAddress;


    constructor() {
        ticket = new NFT();
        nftAddress = address(ticket);

        deployed = new ExclusiveClub(0.1 ether, nftAddress);

        vm.deal(address(0xBAD), 0.1 ether);
    }


}