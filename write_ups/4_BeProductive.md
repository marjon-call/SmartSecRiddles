# BeProductive Solution
The point of this challenge was for you to have another look into how memory in solidity works. First, let's look at the solution, and then we will go over why it works:
```
function test_GetThisPassing_4() public {
    address hacker = address(0xBAD);
    

    vm.startPrank(hacker);
    token.approve(address(target), 10 ether);
    target.createGoal(10 ether, 100 ether);
    target.plan(590 ether);

    target.completeGoal();
    vm.stopPrank();

    assertGt(token.balanceOf(hacker), 700 ether);
}
```
Here are the steps necessary to complete this hack:
1. Create an arbitrary goal.

2. Call `plan()` with the amount equal to your goal's saved amount + the contract's balance of tokens.

3. Call `completeGoal()` and receive all of your stolen tokens!

So why does this work?

Inside of `plan()` we define a memory variable, `envisionedTracker`, and set it to the previously defined memory variable, `currTracker`. This is essentially creating a pointer to `currTracker`. When we update `envisionedTracker`, we are also updating `currTracker`.

Look at the following snippet of code from `plan()`:
```
currTracker.saved += .1 ether;

envisionedTracker.saved += _amount;

goalTracker[msg.sender] = currTracker;
```

We update `currTracker`, but then update `envisionedTracker` immediately after. This sets `currTacker`'s value to `_amount`. Then, `goalTracker[msg.sender]` is set to the updated version of `currTracker`. So essentially, all we need to steal all of the users funds is to set _amount to the balance of the smart contract minus our initial deposit.

When auditing code, keep a close eye on memory variables and their assignment, you will be surprised how many times you will catch a bug related to poor memory management.
