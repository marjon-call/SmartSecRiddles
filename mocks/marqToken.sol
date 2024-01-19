pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MarqToken is ERC20, ERC20Detailed {
    constructor(uint256 initialSupply) ERC20Detailed("MarqyMarqToken", "MRQ", 18) public { }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }
}