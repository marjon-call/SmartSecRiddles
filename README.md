.# SmartSecRiddles: Start Here

## Background

This is a series of solidity CTFs to help auditors and developers become more aware of common vulnerabilities in smart contracts. I find that most CTFs, although useful, do not contain bugs that you typically find in the real world. Each challenge in this CTF is based on a vulnerability I have either found in a contest or bug bounty. 

I find the only way to learn about smart contract security is by doing it. Hopefully these challenges help you to become a better auditor or developer!

If you have any questions, find a bug I missed, or need an audit send me a DM on twitter: `@marqymarq10`

## How To Play
Each challenge comes with an intro README. These can be found in `./Intros`. They contain background information on the smart contract, the goal of the challenge, and a hint to help you solve the challenge, if you need it.

After you read the intro, navigate to `./src` to find the code for the challenge.

Once you discover the vulnerability, write your PoC in `./test`. The goal is to get the provided test case to pass, with the exception of the first challenge. To run the test use:
```
forge test --match-test test_GetThisPassing_x
```
where x is the challenge you are on.
I also included a folder, `./exploits`, if you need a smart contract to complete the challenge.

If you cannot complete the challenge, want validation of your answer, or simply are looking to find out more about the exploit check out `./write_ups`. There, I post my solution to each challenge along with some information on why the vulnerability exists and how to prevent it.



