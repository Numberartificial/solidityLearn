//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//How much ether do you need to pay for a transaction?
//You pay gas spent * gas price amount of ether, where

//gas is a unit of computation
//gas spent is the total amount of gas used in a transaction
//gas price is how much ether you are willing to pay per gas
//Transactions with higher gas price have higher priority to be included in a block.

//Unspent gas will be refunded.

// # There are 2 upper bounds to the amount of gas you can spend

//gas limit (max amount of gas you're willing to use for your transaction, set by you)
//block gas limit (max amount of gas allowed in a block, set by the network)

//Functions and addresses declared payable can receive ether into the contract.

contract EconomicStaffs{
    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = 1 wei == 1;

    uint public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = 1 ether == 1e18;

    // Using up all of the gas that you send causes your transaction to fail.
    // State changes are undone.
    // Gas spent are not refunded.
    // TODO There is no way to check stop-machine(halting) problem.
    function forever() pure public {
        // Here we run a loop until all of the gas are spent
        // and the transaction fails
        uint i = 0;
        while (true) {
            i += 1;
        }
        i = i < 10 ? 1 : 0;
        for (uint j = 1; j < 10; j ++){

        }
    }
}

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    function deposit() public payable {}

    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract.
    function withdraw() public {
        // get the amount of Ether stored in this contract
        uint amount = address(this).balance;

        // send all Ether to owner
        // note Owner can receive Ether since the address of owner is payable
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }

    // Function to transfer Ether from this contract to address from input
    function transfer(address payable _to, uint _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}


/**
 * @dev
 * How to send Ether? 
 * You can send Ether to other contracts by
 
 * transfer (2300 gas, throws error) 
 * send (2300 gas, returns bool) 
 * call (forward all gas or set gas, returns bool) 
 * How to receive Ether? 
 * A contract receiving Ether must have at least one of the functions below
 
 * receive() external payable 
 * fallback() external payable 
 * receive() is called if msg.data is empty, otherwise fallback() is called.
 
 * Which method should you use? 
 * call in combination with re-entrancy guard is the recommended method to use after December 2019.
 
 * Guard against re-entrancy by
 
 * making all state changes before calling other contracts 
 * using re-entrancy guard modifier
 */

contract ReceiveEther {
    /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    /**
    fallback is a function that does not take any arguments and does not return anything.
    It is executed either when
    a function that does not exist is called or
    Ether is sent directly to a contract but receive() does not exist or msg.data is not empty
    fallback has a 2300 gas limit when called by transfer or send.
     */
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendEther {
    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

contract Fallbackd {
    event Log(uint gas);

    // Fallback function must be declared as external.
    fallback() external payable {
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forwards all of the gas)
        emit Log(gasleft());
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract SendToFallback {
    function transferToFallback(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable {
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}