pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "hardhat/console.sol";

/**
 * @dev Implementation of the {ERC20} with periodic vesting plan.
 * 
 */
contract PeriodVestingERC20 is ERC20("PeriodVestingERC20", "PVE20"){

    struct VestingPlan{
        address from;
        address to;
        uint256 amount;
        uint256 planStartAt;
        uint256 planEndAt;
        uint256 period;
        uint256 releaseCount;
        uint256 perPeriodReleaseAmount;
    }

    mapping(address => mapping(address => VestingPlan)) private _vestings;
    mapping(address => VestingPlan[]) private _from_vestings;
    mapping(address => VestingPlan[]) private _to_vestings;
    mapping(address => uint256) private lastWithdrawTimestamp;

    constructor(uint amount){
        address owner = _msgSender();
        _mint(owner, amount);
    }

    function createVestingPlan(
        address to,
        uint256 amount,
        uint256 planStartAt,
        uint256 period,
        uint256 releaseCount,
        uint256 perPeriodReleaseAmount
    ) public {
        address vestingPool = address(this);
        VestingPlan memory vestingPlan = VestingPlan({
            from:_msgSender(),
            to:to,
            amount:amount,
            planStartAt:planStartAt ,
            planEndAt:planStartAt + period * releaseCount - 1,
            period:period,
            releaseCount:releaseCount,
            perPeriodReleaseAmount:perPeriodReleaseAmount
        });
        _vestings[vestingPlan.from][vestingPlan.to] = vestingPlan;
        _from_vestings[vestingPlan.from].push(vestingPlan);
        _to_vestings[vestingPlan.to].push(vestingPlan);
        transfer(vestingPool, vestingPlan.amount);
    }

    function vestingBalance(address account, uint256 fromNowTo) external view returns(uint256){
        return _vestingBalance(account, fromNowTo); 
    }

    function _vestingBalance(address account, uint256 fromNowTo) internal view returns(uint256){
        uint256 balance;
        VestingPlan[] storage to_account_vestings = _to_vestings[account];
        uint256 last = lastWithdrawTimestamp[account];
        for (uint i = 0; i <  to_account_vestings.length; i++){
            VestingPlan storage v = to_account_vestings[i];
            console.log("%s %s %s", fromNowTo, v.planStartAt, v.planEndAt);
            if (fromNowTo >= v.planStartAt && last < v.planEndAt){
                uint256 periods = uint256(
                    (Math.min(fromNowTo, v.planEndAt) - Math.max(last, v.planStartAt - 1)) /
                     v.period
                     );
                balance += periods * v.perPeriodReleaseAmount;
            }
        }
        return balance;
    }

    function withdrawVestingBalance() public returns (bool){
        address owner = _msgSender();
        uint256 balance = _vestingBalance(owner, block.timestamp);
        _transfer(address(this), owner, balance);
        return true;
    }

}

