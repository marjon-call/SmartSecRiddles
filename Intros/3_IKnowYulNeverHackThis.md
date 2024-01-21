# IKnowYulNeverHackThis

## Contract Background
This contract reprsents a simple game. You can either join the red or blue team. Once enough players have joined the game, anyone can call the contract and determine the winner.

Because solidity does not allow for memory array re-sizing, the developer had to get a little creative. The developer uses assembley language to resize the `winners` array properly. 

## Goal
You are the last player to join the game before a winning team is decided. If you join one team you can win the game, and everyone gets their payouts! However, joining the other team allows you to steal everyones winnings. Can you figure out which team allows you to steal all the winnings in one try?

### Hint
This challenge require you to have knowledge of assembly language. If you are unfamiliar with Yul, check out [this begginer tutorial I have written](https://www.alchemy.com/overviews/what-is-yul). I recommend diving into the [memory section](https://www.alchemy.com/overviews/yul-memory) for this challange.

After you know the basics of Yul, I suggest you read the `Push()` section from this [article](https://medium.com/coinsbench/deep-dive-into-solidity-libraries-e9bd7f9061fb). It goes over a library I wrote to resize dynamic arrays. A good portion of the code from this section is copied from the `Push()` section.