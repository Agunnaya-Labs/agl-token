// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {

    IERC20 public governanceToken;

    struct Proposal {
        string description;
        uint256 votes;
        bool executed;
        uint256 deadline;
    }

    Proposal[] public proposals;

    mapping(address => bool) public hasVoted;

    constructor(address tokenAddress) {
        governanceToken = IERC20(tokenAddress);
    }

    function createProposal(string memory description) external {
        proposals.push(
            Proposal({
                description: description,
                votes: 0,
                executed: false,
                deadline: block.timestamp + 3 days
            })
        );
    }

    function vote(uint256 proposalId, uint256 amount) external {
        require(!hasVoted[msg.sender], "Already voted");

        governanceToken.transferFrom(msg.sender, address(this), amount);

        proposals[proposalId].votes += amount;
        hasVoted[msg.sender] = true;
    }

    function execute(uint256 proposalId) external {
        Proposal storage p = proposals[proposalId];

        require(block.timestamp > p.deadline, "Active");
        require(!p.executed, "Done");

        p.executed = true;
    }
}
