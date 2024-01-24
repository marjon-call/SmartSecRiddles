# FuzzThis Solution

Hopefully, this challenge was not too hard. All you have to do is use foundry to create a fuzz test that guesses the proper value. In this case the answer was `2552`.

Let's look at my solution for this challenge:
```
function test_GetThisFailing_1(uint256 _guess) public {

    vm.assume(_guess < 5000);
    bytes memory solution = "loss";



    bytes32 guess = keccak256(abi.encode(15 + _guess));


    bytes memory answer = target.dontHackMePlease(guess);


    assertEq(solution, answer);
}
```

Fairly straight forward. The one caveat of this challenge is you have to go into `foundry.toml` to increase the number of runs for a fuzz test. Here is what that looked like in my `foundry.toml` file:
```
[fuzz]
runs = 1000000
```

I wanted to include one challenge that at least introduced you to fuzz testing. Obviously, this was not the most advanced fuzz test, but you should begin to integrate them whether you are a developer or an auditor!
