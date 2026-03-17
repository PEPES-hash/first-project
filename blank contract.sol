// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TipJar {
    // Owner of the tip jar
    address payable public owner;

    // Event emitted when someone tips
    event Tipped(address indexed from, uint256 amount, string message);

    constructor() {
        owner = payable(msg.sender);
    }

    // Tip function: send ETH with optional message
    function tip(string calldata message) external payable {
        require(msg.value > 0, "Tip must be greater than 0");
        emit Tipped(msg.sender, msg.value, message);
    }

    // Owner can withdraw all ETH safely
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        // Use call pattern for safe transfer
        (bool sent, ) = owner.call{value: balance}("");
        require(sent, "Withdraw failed");
    }

    // Get current balance of the contract
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}