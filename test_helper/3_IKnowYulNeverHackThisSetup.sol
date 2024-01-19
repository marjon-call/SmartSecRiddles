// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { IKnowYulNeverHackThis } from "../src/3_IKnowYulNeverHackThis.sol";
import "forge-std/Test.sol";

contract IKnowYulNeverHackThisHelper is Test {

    IKnowYulNeverHackThis public deployed;

    address[] public players = [address(0x01), address(0x02), address(0x03), address(0x04), address(0x05), address(0x06), address(0x07), address(0x08), address(0x09)];

    constructor() {
        deployed = new IKnowYulNeverHackThis();

        for (uint256 i; i < players.length; ++i) {
            vm.deal(players[i], 1 ether);
            if (i % 2 == 0) {
                vm.prank(players[i]);
                deployed.joinRedTeam{value: 1 ether}();
            } else {
                vm.prank(players[i]);
                deployed.joinBlueTeam{value: 1 ether}();
            }
        }
    }

}