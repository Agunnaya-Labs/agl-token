pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address to, uint amount) external returns (bool);
}

contract LiquidityLocker {
    address public owner;
    uint256 public unlockTime;

    constructor(uint256 _lockDuration) {
        owner = msg.sender;
        unlockTime = block.timestamp + _lockDuration;
    }

    function withdraw(address token) external {
        require(block.timestamp >= unlockTime, "Locked");

        IERC20(token).transfer(
            owner,
            IERC20(token).balanceOf(address(this))
        );
    }
}
