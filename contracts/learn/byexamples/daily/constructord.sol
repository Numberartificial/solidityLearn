// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @dev A constructor is an optional function that is executed upon contract creation.
 */
// Base contract X
contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// There are 2 ways to initialize parent contract with parameters.

// Pass the parameters here in the inheritance list.
contract XY is X("Input to X"), Y("Input to Y") {

}

contract XY1 is X, Y {
    // Pass the parameters here in the constructor,
    // similar to function modifiers.
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}

// Parent constructors are always called in the order of inheritance
// regardless of the order of parent contracts listed in the
// constructor of the child contract.

// Order of constructors called:
// 1. X
// 2. Y
// 3. D
contract XY2 is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// Order of constructors called:
// 1. X
// 2. Y
// 3. E
contract XY3 is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}

/**
 * @dev
 * Solidity supports multiple inheritance. Contracts can inherit other contract by using the is keyword.
 * Function that is going to be overridden by a child contract must be declared as virtual.
 * Function that is going to override a parent function must use the keyword override.
 * note Order of inheritance is important.
 * You have to list the parent contracts in the order from “most base-like” to “most derived”.
 */

 /* Graph of inheritance
    A
   / \
  B   C
 / \ /
F  D,E

*/

// Shadowing is disallowed in Solidity 0.6
// This will not compile
// contract B is A {
//     string public name = "Contract B";
// }
contract A {
    string public name = "contract a";
    function foo() public pure virtual returns (string memory) {
        return "A";
    }

    function getName() public view returns(string memory){
        return name;
    }
}

// Contracts inherit other contracts by using the keyword 'is'.
contract B is A {
    constructor(){
        name = "contract B";
    }

    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }

    // getName() returns "contract B"
}

contract C is A {
    // Override A.foo()
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// Contracts can inherit from multiple parent contracts.
// When a function is called that is defined multiple times in
// different contracts, parent contracts are searched from
// right to left, and in depth-first manner.

contract D is B, C {
    // D.foo() returns "C"
    // since C is the right most parent contract with function foo()
    function foo() public pure override(B, C) returns (string memory) {
        return super.foo();
    }
}

contract E is C, B {
    // E.foo() returns "B"
    // since B is the right most parent contract with function foo()
    function foo() public pure override(C, B) returns (string memory) {
        return super.foo();
    }
}

// Inheritance must be ordered from “most base-like” to “most derived”.
// Swapping the order of A and B will throw a compilation error.
// e.x: contract F is B, A { which will cause error
contract F is A, B{
    function foo() public pure override(A, B) returns (string memory) {
        return super.foo();
    }
}