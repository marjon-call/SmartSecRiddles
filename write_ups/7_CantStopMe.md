# CantStopMe Solution

To pass this challenge you needed to create a DOS. The DOS stems from how the protocol calculates the new price of an auction using the oracle. Before I give you the solution, let's dive deeper into how the smart contracts interact.

`Auction::winAuction()` mints an NFT to the first user to place a bid. If a user does not bid on the price the admin can lower the cost of the NFT with `Auction::setDutchAuctionPrice()`. After someone wins the auction, anyone can call `Auction::createNewAuction()`. This calls `TrustyOracle` in order to create a new price for the next auction. The price is determined off the average price of the previous 5 auctions. If the selling price of this auction is greater than the previous auction, then the average price is increased by 20%. This causes the start price of the next auction to be larger. In order to prevent the price from being too high or too low, every 20 blocks the oracle sets a max and min boundary for the starting price of the auction. The min and max boundary is also determined by the previous 5 sales.

The vulnerability stems from two components. First, having these boundaries so close to the update percentage puts the require statements inside of `Auction::_startNewAuction()` extremely close to reverting. However, the other issue revolves around using `msg.value` instead of `currPrice` for the updated price calculation:
```
// allows user to win the auction by bidding. 
function winAuction() external payable {
    require(msg.value >= currPrice, "pay the price");
    require(inProgress, "No Auction");
    if(lastPrice < currPrice) {
        incrementStartPrice = true;
    }
    lastPrice = msg.value; // this should be currPrice
    
    nft.mint(msg.sender);
    inProgress = false;
}
```

Here is the exploit I wrote:
```
function test_GetThisPassing_7() public {

    address hacker = address(0xBAD);

    vm.startPrank(hacker);
    auction.winAuction{value: 1.2 ether}();
    vm.stopPrank();

    dontpeak.checkIfPasses();
}
```
Notice that even though the price of the auction was 1 ether, I was able to send 1.2 ether. This allowed me to raise the next auction price to higher than the upper boundary, causing the revert.

This bug is ultimately a logic error. Logic errors are the most common type of vulnerability you will find. The only way to catch a logic error is to have in-depth knowledge of the protocol and how it should work.

Bonus Points if you noticed that if the price of an auction went low enough, it could also cause the DOS.
