// SPDX-License-Identifier: MIT
// Numberartificial Contracts (last updated v0.0.1)

pragma solidity ^0.8.0;
contract Storaged {
    uint public val;
    
    constructor(uint v) {
        val = v;
    }

    function setVal(uint v) public {
        val = v;
    }
}