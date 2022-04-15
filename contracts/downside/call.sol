// SPDX-License-Identifier: GPL-3.0

pragma solidity > 0.7.0;
contract C {
  uint256 a;
  // Note: `payable` makes the assembly a bit simpler
  function setA(uint256 _a) public payable {
    a = _a;
  }
}