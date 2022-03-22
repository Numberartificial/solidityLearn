pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {

    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }
   
    function _mintMinerReward() internal {
        _mint(block.coinbase, 1000);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if (!(from == address(0) && to == block.coinbase)) {
          _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }
}