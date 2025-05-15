// Get funds from users
// Withdraw funds
// Set min funding value
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant minimumAmount = 5e18;
    address public immutable owner;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {revert NotOwner();}
        _;
    }
    
    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumAmount, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex; funderIndex < funders.length; funderIndex++) 
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        //Different ways of withdrawing from an address:
        //1. transfer
        // payable(msg.sender).transfer(address(this).balance);
        
        //2. send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "send operation failed");
        
        //3. call (this is the recommended way of doing it)
        (bool callSuccess,) = msg.sender.call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    receive() external payable { 
        fund();
    }

    fallback() external payable {
        fund();
     }
}
