// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../mocks/NFT.sol";
import "../mocks/marqToken.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IStaking {
    struct StakeData {
        uint256 stakeStart;
        uint256 stakeDuration;
        uint256 tokenId;
    }
}

contract Staking is IERC721Receiver, IStaking {

    uint256 locked;
    NFT nft;
    Rewarder rewarder;
    mapping(address => StakeData) public stakeData;
    mapping(address => bool) public isStaking;

    modifier guard() {
        require(locked == 0, "No easy reentrancies here");
        locked = 1;
        _;
        locked = 0;
    }

    constructor(address _nft, address _rewarder) {
        nft = NFT(_nft);
        rewarder = Rewarder(_rewarder);
    }

    function stake(uint256 _tokenId, uint256 _timeLocked) external guard {
        require(_timeLocked > 99, "locked too short");
        require(_timeLocked < 101, "locked too long");
        require(!isStaking[msg.sender], "One NFT at a time");
        nft.safeTransferFrom(msg.sender, address(this), _tokenId);
        stakeData[msg.sender] = StakeData(block.number, _timeLocked, _tokenId);
        isStaking[msg.sender] = true;
    }

    function unstake(uint256 _tokenId, bool claim) external guard {
        require(isStaking[msg.sender], "Stake first");
        StakeData memory userStake = stakeData[msg.sender];
        require(block.number >= userStake.stakeStart + userStake.stakeDuration, "patience is my least favorite virute too");

        if(claim) {
            rewarder.claim(msg.sender);
        }
        nft.safeTransferFrom(address(this), msg.sender, _tokenId);
        isStaking[msg.sender] = false;
        userStake = StakeData(0, 0, 0);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function getStakerData(address _user) external view returns(StakeData memory) {
        return stakeData[_user];
    }


}

contract Rewarder is IStaking{

    address admin;
    uint256 locked;
    Staking staking;
    MarqToken token;
    mapping(address => bool) hasClaimed;


    modifier guard() {
        require(locked == 0, "No easy reentrancies here");
        locked = 1;
        _;
        locked = 0;
    }

    constructor(address _token, address _admin) {
        token = MarqToken(_token);
        admin = _admin;
    }

    function setStaker(address _staking) external guard {
        require(tx.origin == admin, "you are not the admin");
        require(_staking != address(0), "we dont want C4 judges to be spamed with dumb findings"); 
        staking = Staking(_staking);
    }

    function setAdmin(address _admin) external guard {
        require(msg.sender == admin, "you are not the admin");
        require(_admin != address(0), "we dont want C4 judges to be spamed with dumb findings"); 
        admin = _admin;
    }

    function claim() external guard {
        bool isStaking = staking.isStaking(msg.sender);
        StakeData memory userStake = staking.getStakerData(msg.sender);
        require(isStaking, "gotta stake to make money");
        require(block.number >= userStake.stakeStart + userStake.stakeDuration, "dont be hasty");
        require(!hasClaimed[msg.sender], "no double dipping");
        hasClaimed[msg.sender] = true;
        token.mint(1000 ether);
        token.transfer(msg.sender, 1000 ether);
        
    }

    function claim(address _for) external guard {
        bool isStaking = staking.isStaking(_for);
        StakeData memory userStake = staking.getStakerData(msg.sender);
        require(msg.sender == address(staking), "not your rewards");
        require(block.number >= userStake.stakeStart + userStake.stakeDuration, "you know about vm.roll(), right?");
        require(!hasClaimed[msg.sender], "no double dipping");

        hasClaimed[msg.sender] = true;
        token.mint(1000 ether);
        token.transfer(_for, 1000 ether);
    }

}