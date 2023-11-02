// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
    uint public num;

    constructor() {
        num = 0; 
    }

    function setNum(uint value) public {
        num = value;
    }

    function getNum() public view returns (uint) {
        return num;
    }
}