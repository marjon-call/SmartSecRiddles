# IKnowYulNeverHackThis

## Contract Background
This contract reprsents a simple game. You can either join the red or blue team. Once enough players have joined the game, anyone can call the contract and determine the winner.

Because solidity does not allow for memory array re-sizing, the developer had to get a little creative.

## Goal
You are the last player to join the game before a winning team is decided. If you join one team you can win the game, and everyone gets their payouts! However, joining the other team allows you to steal everyones winnings. Can you figure out which team allows you to steal all the winnings in one try?

### Hint