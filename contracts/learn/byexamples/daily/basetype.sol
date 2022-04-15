//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//@dev solidity variables 
// * local
//declared inside a function
//not stored on the blockchain

// * state
//declared outside a function
//stored on the blockchain

// * global 
// reserved field (provides information about the blockchain)

contract Primitives{
      // Default values
    // Unassigned variables have a default value
    // state variables are stored in the blockchain
    bool public defaultBoo; // false
    uint public defaultUint; // 0
    int public defaultInt; // 0
    address public defaultAddr; // 0x0000000000000000000000000000000000000000

    address public constant MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc;//address(this);

    address public immutable INIT_ADDRESS;

    constructor(address init) {
        //Values of immutable variables can be set inside the
        //constructor but cannot be modified afterward.
        INIT_ADDRESS = init;
    }

    function doSome() view public{
        // Local variables are not saved to the blockchain,
        // only exist in runtime memory.
        uint256 i = 456;

        // globle variables which exists in runtime context
        uint timestamp = block.timestamp;
        address sender = msg.sender;
    }
}