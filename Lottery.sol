pragma solidity ^0.8.0;

contract BasicLottery {
    address public owner;
    address[] public players;

    // Set the contract deployer as the owner
    function initializeOwner() public {
        require(owner == address(0), "Owner is already set");
        owner = msg.sender;
    }

    // Allow users to enter the lottery
    function enter() public payable {
        require(msg.value > 0.01 ether, "Minimum 0.01 ETH required");
        players.push(msg.sender);
    }

    // Function to generate a random index
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players)));
    }

    // Pick a random winner and transfer funds
    function pickWinner() public {
        require(msg.sender == owner, "Only owner can pick a winner");
        require(players.length > 0, "No players in the lottery");
        
        uint index = random() % players.length;
        payable(players[index]).transfer(address(this).balance);
        
        // Reset the lottery
        delete players;
    }
}
