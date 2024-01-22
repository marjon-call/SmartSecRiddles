// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;


contract IKnowYulNeverHackThis {

    address[] public redTeam;
    address[] public blueTeam;
    bool locked;
    uint256 constant minAmountOfPlayers = 10;
    uint256 public playersCount;
    mapping(address => bool) public isPlaying;
    enum Team { Red, Blue }
    


    function joinRedTeam() external payable {
        require(msg.value == 1 ether, "This game ain't free");
        require(!isPlaying[msg.sender], "Start playing already!");

        redTeam.push(msg.sender);

        isPlaying[msg.sender] = true;
        playersCount++; 
    }

    function joinBlueTeam() external payable {
        require(msg.value == 1 ether, "This game ain't free");
        require(!isPlaying[msg.sender], "Start playing already!");

        blueTeam.push(msg.sender); 

        isPlaying[msg.sender] = true;
        playersCount++; 
    }
    
    function defineWinners(bool _isBlueTeam) external {
        require(locked == false, "This isn't a reentrancey challenge");
        require(playersCount >= minAmountOfPlayers, "Game isn't over yet");

        locked = true;

        address[] memory winners = new address[](1);

        if (_isBlueTeam) {
            for(uint256 j; j < blueTeam.length; ++j) {
                address winner = blueTeam[j];
                assembly {

                    let location := winners
  
                    let length := mload(winners)
        
                    let nextMemoryLocation := add( location, mul( length, 0x20 ) )
                    let freeMem := mload(0x40)

                    let newMsize := add( freeMem, 0x20 )

                    if iszero( eq( freeMem, nextMemoryLocation) ){
                        let currVal
                        let prevVal
                    
                        for { let i := nextMemoryLocation } lt(i, newMsize) { i := add(i, 0x20) } {
                        
                            currVal := mload(i)
                            mstore(i, prevVal)
                            prevVal := currVal
                        
                        }
                    }

                    mstore(nextMemoryLocation, winner)
        
                    length := add( length, 1 )
        
                    mstore( location, length )

                    mstore(0x40, newMsize )
                }
            }
            
        } else {
            for(uint256 j; j < redTeam.length; ++j) {
                address winner = redTeam[j];
                assembly {

                    let location := winners
     
                    let length := mload(winners)
        
                    // @todo !! THIS CHANGED FROM PUSH !! to remove 0 address
                    let nextMemoryLocation := add( location, mul( length, 0x20 ) )
                    let freeMem := mload(0x40)

                    let newMsize := add( freeMem, 0x20 )

                    if iszero( eq( freeMem, nextMemoryLocation) ){
                        let currVal
                        let prevVal
                    
                        for { let i := nextMemoryLocation } lt(i, newMsize) { i := add(i, 0x20) } {
                        
                            currVal := mload(i)
                            mstore(i, prevVal)
                            prevVal := currVal
                        
                        }
                    }
                    
                    mstore(nextMemoryLocation, winner)
        
                    
                    length := add( length, 1 )

                    mstore(0x40, newMsize )
                }
            }
        }

        uint256 shareOfPrize = address(this).balance / winners.length;

        uint256 i;
        uint256 winnersLength = winners.length;
        for(i; i < winners.length; ++i) {
            (bool sent, bytes memory data) = winners[i].call{value: shareOfPrize}("");
        }

        locked = false;
    }
}