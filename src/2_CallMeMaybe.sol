// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "./interfaces/IERC20.sol";

contract CallMeMaybe {

    address token;
    mapping(address => uint256) depositAmount;
    mapping(address => bool) depositers;

    constructor(address _token) {
        token = _token;
    }

    // Join the group
    function joinGroup(uint256 _amount) external {

        IERC20(token).transferFrom(msg.sender, address(this), _amount);

        depositers[msg.sender] = true;
        depositAmount[msg.sender] += _amount;
    }

    // Leave the group
    function leaveGroup() external {
        depositers[msg.sender] = false;
        IERC20(token).transfer(msg.sender, depositAmount[msg.sender]);
        depositAmount[msg.sender] = 0;
    }

    // group mebers can flashloan tokens
    function usePooledWealth(bytes memory _calldata, address _target) external {
        require(depositers[msg.sender], "Don't be shy, join the group first");
        uint256 startBalance = IERC20(token).balanceOf(address(this));

        // make call here
        _target.call(_calldata);

        require(IERC20(token).balanceOf(address(this)) >= startBalance, "Isn't the point of crypto to trust each other, smh");
    }

}