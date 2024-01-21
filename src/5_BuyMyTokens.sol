// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../mocks/marqToken.sol";

contract BuyMyTokens {

    MarqToken token1;
    MarqToken token2;
    MarqToken token3;
    MarqToken[] tokens;
    mapping(MarqToken=>uint256) tokenPrices;


    constructor(address _token1, address _token2, address _token3) {
        token1 = MarqToken(_token1);
        token2 = MarqToken(_token2);
        token3 = MarqToken(_token3);
        tokens.push(token1);
        tokens.push(token2);
        tokens.push(token3);
        tokenPrices[token1] = 0.1 ether;
        tokenPrices[token2] = 0.2 ether;
        tokenPrices[token3] = 0.3 ether;
    }

    function _checkPurchasingPower(uint256 _amountOfEtherAvailable, uint256 _amount, uint256 _price) internal {
        uint256 cost = _price * _amount;
        require(cost >= _amountOfEtherAvailable, "dont be that guy; pay for your tokens");
    }


    function purchaseTokens(uint256[] memory _amounts) external payable {
        require(_amounts.length == 3, "There are 3 tokens");
        for(uint256 i; i < 3; i++) {
            MarqToken token = tokens[i];
            uint256 amount = _amounts[i];
            uint256 price = tokenPrices[token];
            _checkPurchasingPower(msg.value, amount, price);
            token.mint(amount * 10**18);
            token.transfer(msg.sender, amount * 10**18);
        }
    }


}