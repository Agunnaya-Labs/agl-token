// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Tokenomics {

    IERC20 public token;

    uint256 public totalBurned;
    uint256 public emissionsRate = 5; // % yearly inflation (simplified)

    address public owner;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        owner = msg.sender;
    }

    // Track burns manually (called from UI or system)
    function recordBurn(uint256 amount) external {
        totalBurned += amount;
    }

    // Simulated emissions calculation
    function projectedSupply(uint256 currentSupply) external view returns (uint256) {
        return currentSupply + (currentSupply * emissionsRate / 100);
    }
}
