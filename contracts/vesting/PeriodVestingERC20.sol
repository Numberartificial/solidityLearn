pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract PeriodVestingERC20 is ERC20("PeriodVestingERC20", "PVE20"){

    struct VestingPlan{
        address from;
        address to;
        uint256 amount;
        uint256 planStartAt;
        uint256 period;
        uint256 releaseCount;
        uint256 perPeriodReleaseAmount;
    }

    mapping(address => mapping(address => VestingPlan)) private _vestings;
    mapping(address => VestingPlan[]) private _from_vestings;
    mapping(address => VestingPlan[]) private _to_vestings;

    constructor(){
        address owner = _msgSender();
        _mint(owner, 10000);
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
            planStartAt:planStartAt,
            period:period,
            releaseCount:releaseCount,
            perPeriodReleaseAmount:perPeriodReleaseAmount
        });
        _vestings[vestingPlan.from][vestingPlan.to] = vestingPlan;
        _from_vestings[vestingPlan.from].push(vestingPlan);
        _to_vestings[vestingPlan.to].push(vestingPlan);
        transfer(vestingPool, vestingPlan.amount);
    }

    function vestingBalance(address account, uint256 fromNowTo) public view returns(uint256){
        uint256 balance;
        VestingPlan[] storage to_account_vestings = _to_vestings[account];
        for (uint i = 0; i <  to_account_vestings.length; i++){
            VestingPlan storage v = to_account_vestings[i];
            console.log("%s %s", fromNowTo, v.planStartAt);
            uint256 periods = uint256((fromNowTo - v.planStartAt) / v.period);
            balance += periods * v.perPeriodReleaseAmount;
        }
        return balance;
    }

    // function createVestingPlan(VestingPlan[] memory vestingPlans) public {
    //     address msgSender = _msgSender();
    //     for (uint i = 0; i < vestingPlans.length; i++) {
    //         _vestings[msgSender].push(VestingPlan({
    //             from: vestingPlans[i],
    //             voteCount: 0
    //         }));
    //     }
    // }
}

