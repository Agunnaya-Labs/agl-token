// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public token;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    uint256 public rewardRate = 10; // simple fixed reward %

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Invalid amount");

        token.transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;
    }

    function unstake() external {
        Stake memory s = stakes[msg.sender];
        require(s.amount > 0, "Nothing staked");

        uint256 reward = (s.amount * rewardRate) / 100;

        stakes[msg.sender].amount = 0;

        token.transfer(msg.sender, s.amount + reward);
    }
}
