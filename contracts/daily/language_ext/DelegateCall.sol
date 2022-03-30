// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;
 
// NOTE: Deploy this contract first
contract OLD {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public sender;
    uint public value;
 
    function setVars(uint _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}
 
contract New1 {
    uint public num;
    address public sender;
    uint public value;
 
    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
 
contract New2 {
    uint public num;
    address public sender;
    uint public value;
 
    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.call(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}
 
contract New3 {
    uint public num1;
    uint public value1;
    uint public sender1;
 
    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }
}