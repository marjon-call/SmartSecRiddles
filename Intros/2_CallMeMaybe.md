# CallMeMaybe

## Contract Background
This smart contract allows users to pool their tokens together, and call other smart contracts with a greater sum of tokens. First you need to deposit tokens to join the group, but don't worry you can leave at any time. However, it verifies that no one can steal the tokens by asserting that the balance doesn't change.

## Goal
You start this challenge with 1 token (1e18), and the contract currently holds 300 tokens. The goal is for you to steal the 300 tokens from the contract. 

Bonus points if you can manage to steal 600 tokens.

### Hint
Here is the transaction history for the contract:

| Address   |      TX      |  Amount | User Balance |
|----------|:-------------:|------:| ------:|
| address(0x01) |  approve | max |  600 |
| address(0x01) |  joinGroup | 300e18 |  300 |
| address(0x02) |    approve   |   max |  600 |
| address(0x02) |  joinGroup | 300e18 |  300 |
| address(0x03) | approve |    max |  600 |
| address(0x03) |  joinGroup | 300e18 |  300 |
| address(0x03) |  leaveGroup | 300e18 |  600 |