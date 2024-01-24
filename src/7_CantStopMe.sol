// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "../mocks/NFT.sol";

contract Auction {

    uint256 public minPrice;
    uint256 public maxPrice;
    uint256 public lastPrice;
    uint256 public currPrice;
    uint256 public increment;
    address public oracle;
    bool public inProgress;
    bool public incrementStartPrice;
    address private admin;
    NFT public nft;

    constructor(address _admin, address _nft, uint256 _increment, uint256 startPrice) {
        admin = _admin;
        increment = _increment;
        nft = NFT(_nft);
        currPrice = startPrice;
        inProgress = true;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "you are not the admin");
        _;
    }

    // updates admin
    function setAdmin(address _admin) external onlyAdmin {
        require(_admin != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        admin = _admin;
    }

    // sets oracle
    function setOracle(address _oracle) external onlyAdmin {
        require(_oracle != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        oracle = _oracle;
    }

    // changes price increment of auction
    function setIncrement(uint256 _increment) external onlyAdmin {
        increment = _increment;
    }

    // updates price if no one bids
    function setDutchAuctionPrice(uint256 _price) external payable onlyAdmin {
        currPrice -= increment;
    }

    // pulls out ether to treasury
    function pullToTreasury(address _treasury) external onlyAdmin {
        (bool success, ) = _treasury.call{value: address(this).balance}("");
    }

    // updates max and min price for an auction
    function updatePriceDifferential(uint256 _minPrice, uint256 _maxPrice) external {
        require(msg.sender == oracle, "Not Oracle"); 
        minPrice = _minPrice;
        maxPrice = _maxPrice;
    }

    // allows user to win the auction by bidding. 
    function winAuction() external payable {
        require(msg.value >= currPrice, "pay the price");
        require(inProgress, "No Auction");
        if(lastPrice < currPrice) {
            incrementStartPrice = true;
        }
        lastPrice = msg.value;
        
        nft.mint(msg.sender);
        inProgress = false;
    }

    // starts new auction
    function createNewAuction() external {
        require(!inProgress, "Auction");
        _startNewAuction();
    }

    // helper function to set new price for the auction
    function _startNewAuction() private {
        TrustyOracle(oracle).addPriceToHistory();
        currPrice = TrustyOracle(oracle).getNewAuctionPrice(lastPrice);
        require(currPrice <= maxPrice, "Price Too High");
        require(currPrice >= minPrice, "Price Too Low"); 
        inProgress = true;
        incrementStartPrice = false;
    }

    
}



contract TrustyOracle {

    uint256 constant epochLength = 20;
    address private admin;
    uint256 public previousUpdateBlock;
    uint256[] public previousPrices;
    Auction auction;

    constructor(address _admin, address _auction) {
        admin = _admin;
        auction = Auction(_auction);
        uint256 i;
        while (i < 5) {
            previousPrices.push(auction.currPrice());
            unchecked {
                ++i;
            }
        }
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "no price manipulation allowed");
        _;
    }

    // sets new admin
    function setAdmin(address _admin) external onlyAdmin {
        require(_admin != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        admin = _admin;
    }


    // we don't want too large of a price fluctuation based off one bad sale
    // so we need to verify that the price is within a certain range
    function setMaxDifferentialPrice() external onlyAdmin {
        require(previousUpdateBlock + epochLength >= block.number, "read the clock");
        previousUpdateBlock = block.number;
        
        uint256 averagePrice = _calculatePriceImpact();

        uint256 minPrice = averagePrice * 8000 / 10000;
        uint256 maxPrice = averagePrice * 12000 / 10000;

        auction.updatePriceDifferential(minPrice, maxPrice);
    }

     // adds current price to  
    function addPriceToHistory() external {
        require(msg.sender == address(auction));
        uint256 lastPrice = auction.lastPrice();
        previousPrices.push(lastPrice);
    }

    // calculate the new auction price based off previous auction sales
    function getNewAuctionPrice(uint256 _lastPrice) external view returns(uint256) {
        uint256 averagePrice = _lastPrice;
        uint256 length = previousPrices.length;
        uint256 i;
        for (i; i < 4; ++i) {
            averagePrice += previousPrices[length - i - 1];
        }
        if(auction.incrementStartPrice()) {
            averagePrice = averagePrice * 12000 / 10000;
        }
        return averagePrice / 5;
    }

    // get the average sale price from the last 5 auctions
    function _calculatePriceImpact() private view returns(uint256) {
        uint256 averagePrice;
        uint256 length = previousPrices.length;
        uint256 i;
        for (i; i < 5; ++i) {
            averagePrice += previousPrices[length - i - 1];
        }
        return averagePrice / 5;
    }

}