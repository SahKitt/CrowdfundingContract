// SPDX-License-Identifier: MIT
// Author: Kelvin Mulei
pragma solidity ^0.8.0;

contract Crowdfunding {
    // State variables
    address public owner;
    uint public goal;
    uint public deadline;
    mapping(address => uint) public contributions;
    bool public goalReached;
    uint public totalRaised;

    // Events
    event ContributionReceived(address indexed contributor, uint amount);
    event GoalReached(uint totalRaised);
    event Withdrawal(address indexed owner, uint amount);
    event RefundIssued(address indexed contributor, uint amount);

    // Constructor
    constructor(uint _goal, uint _duration) {
        require(_goal > 0, "Goal must be greater than zero");
        require(_duration > 0, "Duration must be greater than zero");
        
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _duration;
        goalReached = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier campaignActive() {
        require(block.timestamp < deadline, "Funding period has ended");
        _;
    }

    modifier campaignEnded() {
        require(block.timestamp >= deadline, "Funding period is not over yet");
        _;
    }

    modifier hasContributed() {
        require(contributions[msg.sender] > 0, "You have no contributions to refund");
        _;
    }

    // Function to contribute
    function contribute() public payable campaignActive {
        require(msg.value > 0, "Contribution must be greater than zero");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        if (totalRaised >= goal && !goalReached) {
            goalReached = true;
            emit GoalReached(totalRaised);
        }

        emit ContributionReceived(msg.sender, msg.value);
    }

    // Withdraw function
    function withdraw() public onlyOwner {
        require(goalReached, "Goal not reached");
        uint amount = address(this).balance;
        require(amount > 0, "No funds available for withdrawal");
        
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Withdrawal failed");

        emit Withdrawal(owner, amount);
    }

    // Refund function
    function refund() public campaignEnded hasContributed {
        require(!goalReached, "Goal has been reached, cannot refund");

        uint contribution = contributions[msg.sender];
        contributions[msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: contribution}("");
        require(success, "Refund failed");

        emit RefundIssued(msg.sender, contribution);
    }
}
