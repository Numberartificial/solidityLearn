pragma solidity >= 0.7.0 < 0.9.0;

library adder {
    function add(uint[] memory self) public pure returns(uint)
    {
        uint sum = 0;
        for (uint i = 0;i < self.length; i++)
        {
            sum += self[i];
        }
        return sum;
    }
}