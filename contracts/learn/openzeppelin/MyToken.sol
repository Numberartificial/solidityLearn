// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract MyToken is ERC20, AccessControl, Ownable {
    // Create a new role identifier for the minter role
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    struct Without{
        uint len;
        uint[] array;
    }

    mapping(address => Without) withouts;
    uint[] stateVar = [1,4,5];
    
    function foo(uint[] calldata states) public{
        // case 1 : from storage to memory
        uint[] memory y = stateVar; // copy the content of stateVar to y
        
        // case 2 : from memory to storage
        y[0] = states[0];
        y[1] = states[1];
        y[2] = states[2];
        // call data is read only
        // states[1] = 1;
        
        stateVar = y; // copy the content of y to stateVar
        
        // case 3 : from storage to storage
        uint[] storage z = stateVar; // z is a pointer to stateVar
        
        z[0] = 38;
        z[1] = 89;
        z[2] = 72;
    }

    constructor(address minter, address burner) ERC20("MyToken", "TKN") {
        console.log("without init address %s", withouts[minter].len);
        _setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
        _setRoleAdmin(MINTER_ROLE, ADMIN_ROLE);
        _setRoleAdmin(BURNER_ROLE, ADMIN_ROLE);
        _setupRole(MINTER_ROLE, minter);
        _setupRole(BURNER_ROLE, burner);
    }

    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyRole(BURNER_ROLE) {
        _burn(from, amount);
    }
    // constructor(address minter) ERC20("MyToken", "TKN") {
    //     // Grant the minter role to a specified account
    //     _setupRole(MINTER_ROLE, minter);
    // }

    // function mint(address to, uint256 amount) public returns(bool){
    //     // Check that the calling account has the minter role
    //     require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
    //     _mint(to, amount);
    //     console.log("mint %s with %d tokens", to, amount);
    //     return true;
    // }

    function testToString(uint256 num) public view returns (string memory) {
    //@see https://docs.soliditylang.org/en/v0.8.4/units-and-global-variables.html#type-information
        console.log("min %s max %s, 2**32 %s", type(uint32).min, type(uint32).max, 1<<32);
        return Strings.toString(num);
    }
}