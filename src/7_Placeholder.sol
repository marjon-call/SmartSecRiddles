// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;


// end up making DOS swapper creates swap the uopdated timestam is at top of range. change in it forces DOS from try catch

contract Swapper {

    uint256 minPrice;
    uint256 maxPrice;
    uint526 lastPrice;
    uint256 currPrice;
    address oracle;

    constructor(address _oracle, address _admin) {
        oracle = _oracle;
        admin = _admin;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "you are not the admin");
        _;
    }

    function setAdmin(address _admin) external onlyAdmin {
        require(_admin != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        admin = _admin;
    }

    function setOracle(address _oracle) external onlyAdmin {
        require(_oracle != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        oracle = _oracle;
    }

    function updatePrice(uint256 _minPrice, uint256 _maxPrice) external {
        require(msg.sender == oracle, "Not Oracle");
        require(price < _maxPrice, "Price Too High");
        require(price > _minPrice, "Price Too Low); 
        minPrice = _minPrice;
        maxPrice = _maxPrice;
    }

    function setDutchAuctionPrice(uint256 _price) externanl payable onlyAdmin {
        require(currPrice > _price)
        currPrice = _price;


    }
}



contract TrustyOracle {

    uint256 constant = 20;
    address public admin;
    // @todo make checking this part of solution
    uint256 public previousUpdateBlock;
    uint256[] public previousPrices;
    Swapper swapper;

    

    constructor(address _admin, address _swapper) {
        admin = _admin;
        swapper = Swapper(_swapper);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "no price manipulation allowed");
        _;
    }

    function setAdmin(address _admin) external onlyAdmin {
        require(_admin != address(0), "we dont want CodeHawks judges to be spamed with dumb findings"); 
        admin = _admin;
    }

    function addPriceToHistory() external onlyAdmin {
        uint256 lastPrice = swapper.getLastPrice();
        previousPrices.push(lastPrice);
    }

    function calculatePriceImpact() internal view returns(uint256) {
        uint256 averagePrice;
        uint256 length = previousPrices.length;
        uint256 i;
        for (i; i < 5; ++i) {
            averagePrice += previousPrices[length - i];
        }
        return averagePrice / 5;
    }

    function setMaxDifferentialPrice() external onlyAdmin {

        uint256 minPrice = averagePrice * 8000 / 10000;
        uint256 maxPrice = averagePrice * 12000 / 10000;

        swapper.updatePrice(minPrice, maxPrice);
    }


}