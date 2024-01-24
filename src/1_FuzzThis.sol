// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

contract FuzzThis {
    
    bytes32 private immutable secretPassword;

    constructor(uint256 _specialNumber) {
        require(_specialNumber < 5000, "Dont make it too hard");
        secretPassword = keccak256( abi.encode( 15 + _specialNumber ));
    }

    function dontHackMePlease(bytes32 _collectionOfHexadecimal) external returns(bytes memory) {
        
        if (_collectionOfHexadecimal == secretPassword) {
            console.logBytes32(secretPassword);
            return "win";
        }

        return "loss";

    }
}
