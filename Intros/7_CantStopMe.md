# CantStopMe

## Contract Background
This protocol uses two smart contracts: `Auction` & `TrustyOracle`. `Auction` performs a [dutch auction](https://www.investopedia.com/terms/d/dutchauction.asp) in order to sell an NFT. `Auction` uses `TrustyOracle` to set the starting price of the auction based off previous auction prices.

## Goal
You start with 2 ether, cause damage.

### Hint
Don't trust the name of the challenge.

If you are still stuck, check `CantStopMeHelper::checkIfPasses()` to see what leads to you passing this challenge
