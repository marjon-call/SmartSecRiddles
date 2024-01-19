pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MarqToken is ERC20 {
    constructor() ERC20("MarqyMarqToken", "MRQ") public { }

    function mint(uint256 _amount) external {
        _mint(msg.sender, _amount);
    }
}