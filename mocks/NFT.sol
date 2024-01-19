pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract NFT is ERC721 {

    uint256 tokenId;
    constructor() ERC721("MarqNFT", "NFT") {}

    function mint(address _to) external {
        _mint(_to, tokenId);
        tokenId += 1;
    }
}