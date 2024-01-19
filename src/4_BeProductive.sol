// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../mocks/marqToken.sol";

contract BeProductive {

    struct ProgressTracker {
        uint256 saved;
        uint256 target;
    }

    MarqToken token;
    mapping(address => ProgressTracker) public goalTracker;
    mapping(address => bool) public isMotivated;


    constructor(address _token) {
        token = MarqToken(_token);
    }


    // start saving by creating a goal for yourself
    // your funds will be locked until you reach your savings goal
    function createGoal(uint256 _startAmount, uint256 _goal) external {
        require(!isMotivated[msg.sender], "Dont quit on your previous dream");
        token.transferFrom(msg.sender, address(this), _startAmount);
        goalTracker[msg.sender] = ProgressTracker(_startAmount, _goal);
        isMotivated[msg.sender] = true;
    }

    // once you saved enough to reach your goal, you can call me to recieve your funds + rewards for saving
    function completeGoal() external {
        ProgressTracker memory tracker = goalTracker[msg.sender];
        require(tracker.target <= tracker.saved);
        require(isMotivated[msg.sender], "Set a goal first");

        goalTracker[msg.sender] = ProgressTracker(0, 0);
        isMotivated[msg.sender] = false;

        token.mint(100 ether);
        token.transfer(msg.sender, tracker.saved + 100 ether);
    }

    // add funds to your goal
    function save(uint256 _amount) external {
        require(isMotivated[msg.sender], "Set a goal first");
        token.transferFrom(msg.sender, address(this), _amount);
        ProgressTracker memory tracker = goalTracker[msg.sender];
        tracker.saved += _amount;
        goalTracker[msg.sender] = tracker;
    }

    // allows user to see how far they are from their goal. 
    // Additionally, adds 0.1 ether to their account for caring about their goal
    function plan(uint256 _amount) external returns (int256) {
        require(isMotivated[msg.sender], "Set a goal first");
        ProgressTracker memory currTracker = goalTracker[msg.sender];
        ProgressTracker memory envisionedTracker = currTracker;

        // mint .1 token for user as a reward for planning ahead
        token.mint(0.1 ether);
        currTracker.saved += .1 ether;

        envisionedTracker.saved += _amount;

        goalTracker[msg.sender] = currTracker;

        return int256(envisionedTracker.target) - int256(envisionedTracker.saved);
    }

}