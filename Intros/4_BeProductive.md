# BeProductive

## Contract Background
This smart contract helps users to save money. A user is required to create a goal and lock up their tokens. Once the user reaches their goal, they can call `completeGoal()` to receive their saved amount + an additional 100 tokens as a reward. To incentivise planning ahead, the smart contract has a function called `plan()`. This function allows a user to see how far they are from their goal. Additionally, `plan()` rewards a user by mining them 0.1 tokens.
## Goal
You start out with 10 tokens, and there are 590 tokens locked in the smart contract. Can you steal all 590 tokens, and receive the 100 token reward?

### Hint
Do not just repeatedly call `plan` until you have enough tokens. Realistically, you will waste way more in gas costs than you would end up stealing.
