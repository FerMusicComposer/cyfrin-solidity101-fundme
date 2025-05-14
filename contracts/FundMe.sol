// Get funds from users
// Withdraw funds
// Set min funding value
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FundMe {
    function fund() public payable {
        require(msg.value >= 1e18, "please send a minimum of 1 ETH");
    }
    function withdraw() public {}


}
