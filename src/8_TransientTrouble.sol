// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "../mocks/NFT.sol";

contract ExclusiveClub {

    uint256 public ticketCost;
    NFT public ticket;

    event IamCool(address PersonOfSignificance);

    constructor(uint256 _ticketCost, address _ticket) {
        ticketCost = _ticketCost;
        ticket = NFT(_ticket);
    }

    function payAdmission() public payable {
        require(msg.value >= ticketCost, "this is an exclusive club, payup");
        assembly {
            tstore(0, 1)
        }
    }

    function receiveTicket() public {
        bool isAdmissionPayed;
        assembly {
            isAdmissionPayed := tload(0)
        }
        require(isAdmissionPayed, "tickets arn't free");

        ticket.mint(msg.sender);
    }

    function externalJoinClub() external payable {
        payAdmission();
        receiveTicket();
    }


    function flauntWealth() public {
        require(ticket.balanceOf(msg.sender) > 0, "no poors");
        emit IamCool(msg.sender);
    }

}