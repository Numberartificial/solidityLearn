// SPDX-License-Identifier: MIT
// Numberartificial Contracts (last updated v0.0.1)

pragma solidity ^0.8.0;

import "./Storaged.sol";

contract UseStoraged {
    Storaged public s;
    constructor(Storaged addr)  {
        s = addr;
    }

    function setV(uint v) public returns(bool){
        s.setVal(v);
        return true;
    }

    function getV() public view returns(uint){
        return s.val();
    }
}