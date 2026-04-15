// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Treasury {

    address public dao;

    constructor(address daoAddress) {
        dao = daoAddress;
    }

    function withdraw(address token, address to, uint256 amount) external {
        require(msg.sender == dao, "Not DAO");

        IERC20(token).transfer(to, amount);
    }
}
