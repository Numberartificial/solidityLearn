// contracts/MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract MyToken is ERC20, AccessControl, Ownable {
    // Create a new role identifier for the minter role
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor(address minter) ERC20("MyToken", "TKN") {
        // Grant the minter role to a specified account
        _setupRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public returns(bool){
        // Check that the calling account has the minter role
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
        console.log("mint %s with %d tokens", to, amount);
        return true;
    }

    function testToString(uint256 num) public pure returns (string memory) {
        return Strings.toString(num);
    }
}