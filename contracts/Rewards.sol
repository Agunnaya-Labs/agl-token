// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Rewards {

    IERC20 public token;

    struct User {
        uint256 staked;
        uint256 rewardDebt;
        uint256 lastUpdate;
    }

    mapping(address => User) public users;

    uint256 public rewardRatePerSecond = 1e15; // simplified emission rate

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }

    function stake(uint256 amount) external {
        _update(msg.sender);

        token.transferFrom(msg.sender, address(this), amount);

        users[msg.sender].staked += amount;
    }

    function _update(address user) internal {
        User storage u = users[user];

        if (u.staked > 0) {
            uint256 timeDiff = block.timestamp - u.lastUpdate;
            uint256 reward = timeDiff * rewardRatePerSecond * u.staked / 1e18;

            u.rewardDebt += reward;
        }

        u.lastUpdate = block.timestamp;
    }

    function claim() external {
        _update(msg.sender);

        uint256 reward = users[msg.sender].rewardDebt;
        users[msg.sender].rewardDebt = 0;

        require(reward > 0, "No rewards");

        token.transfer(msg.sender, reward);
    }
}
