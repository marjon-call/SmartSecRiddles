// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { TrustyOracle, Auction } from "../src/7_CantStopMe.sol";
import "../mocks/NFT.sol";
import "forge-std/Test.sol";


contract CantStopMeHelper is Test {

    Auction public deployed1;
    TrustyOracle public deployed2;
    address public nftAddress;
    NFT public nft;
    address public admin = address(0x1111);


    constructor() {
        nft = new NFT();
        nftAddress = address(nft);

        deployed1 = new Auction(admin, nftAddress, 0.1 ether, 1 ether);
        deployed2 = new TrustyOracle(admin, address(deployed1));

        vm.prank(admin);
        deployed1.setOracle(address(deployed2));

        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();

        vm.deal(address(0xBAD), 2 ether);
    }


    function checkIfPasses() public {
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.roll(block.number + 20);
        vm.prank(admin);
        deployed2.setMaxDifferentialPrice();
        vm.expectRevert("Price Too High");
        deployed1.createNewAuction();
    }

    


}