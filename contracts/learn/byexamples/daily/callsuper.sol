// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "hardhat/console.sol";
/**
 * @dev
 * Parent contracts can be called directly, or by using the keyword super.
 * By using the keyword super, all of the immediate parent contracts will be called.
 */
/* Inheritance tree
   A
 /  \
B   C
 \ /
  D
*/

contract Callsuper_A {
    // This is called an event. You can emit events from your function
    // and they are logged into the transaction log.
    // In our case, this will be useful for tracing function calls.
    event Log(string message);

    function foo() public virtual {
        emit Log("A.foo called");
        console.log("A.foo");
    }

    function bar() public virtual {
        emit Log("A.bar called");
        console.log("A.bar");
    }
    function cannot() public {
        emit Log("A.bar called");
        console.log("A.bar");
    }
}

contract Callsuper_B is Callsuper_A {
    function foo() public virtual override {
        emit Log("B.foo called");
        console.log("B.foo");
        Callsuper_A.foo();
    }

    function bar() public virtual override {
        emit Log("B.bar called");
        console.log("B.bar");
        super.bar();
    }
    function cannot() 
}

contract Callsuper_C is Callsuper_A {
    function foo() public virtual override {
        emit Log("C.foo called");
        console.log("C.foo");
        Callsuper_A.foo();
    }

    function bar() public virtual override {
        emit Log("C.bar called");
        console.log("C.bar");
        super.bar();
    }
}

contract Callsuper_D is Callsuper_B, Callsuper_C {
    // Try:
    // - Call D.foo and check the transaction logs.
    //   Although D inherits A, B and C, it only called C and then A.
    // - Call D.bar and check the transaction logs
    //   D called C, then B, and finally A.
    //   Although super was called twice (by B and C) it only called A once.

    // D.foo
    // C.foo
    // A.foo
    function foo() public override(Callsuper_B, Callsuper_C) {
        console.log("D.foo");
        super.foo();
    }


    // D.bar
    // C.bar
    // B.bar
    // A.bar
    // TODO WHY??
    function bar() public override(Callsuper_B, Callsuper_C){
        console.log("D.bar");
        super.bar();
    }
}
