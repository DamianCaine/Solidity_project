// SPDX-License-Identifier: Unlicensed

import 'hardhat/console.sol';
pragma solidity ^0.8.7;

contract CoinFlip{
    /*
        Name: Siddharth Mondal
        University: VIT University, Vellore
        Reg. No.: 18BME0155
        Submission for Web3 task
    */
    address owner;
    mapping(uint => Better) betters;
    uint flip;

    constructor() {
        owner=msg.sender; //storing address of user deploying the contract
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    
    struct Better{
        address payable walletAddress;
        uint betAmount;
        uint bet;
    }

    //adding betters
    function addBetters(uint _id, address payable _walletAddress, uint _betAmount, uint _bet) public payable onlyOwner{
        betters[_id]=Better(_walletAddress, _betAmount, _bet);
    }

    //checking if betters have enough balance to bet
    function checkBalance(uint _id) public view returns(uint){
        require(betters[_id].betAmount<(betters[_id].walletAddress).balance, "Insufficient funds!");
        return (betters[_id].walletAddress).balance;        
    }

    //random coin flip
    function coinFlip() public onlyOwner{
        flip= uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,msg.sender)))%2;
        console.log(flip);
    }

    //checking if any betters won
    function checkBet(uint _id) public payable{
        if(betters[_id].bet == flip){
            (betters[_id].walletAddress).transfer(msg.value);
            console.log("You won the bet! Current Balance: ",(betters[_id].walletAddress).balance);
        }
        else{
            console.log("You lost the best. Current Balance: ",(betters[_id].walletAddress).balance);
        }
    }
}