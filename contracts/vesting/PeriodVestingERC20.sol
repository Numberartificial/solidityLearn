pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "hardhat/console.sol";
import "./IPeriodVestingPlan.sol";

/**
 * @dev Implementation of the {IPeriodVestingPlan} to create periodic vesting plan with ERC20 tokens.
 * 
 */
contract PeriodVestingERC20 is ERC20("PeriodVestingERC20", "PVERC20"), IPeriodVestingPlan{

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

   // An address type variable is used to store ethereum accounts.
    address public owner;

    mapping(address => mapping(address => VestingPlan)) private _vestings;
    mapping(address => VestingPlan[]) private _from_vestings;
    mapping(address => VestingPlan[]) private _to_vestings;
    mapping(address => uint256) private lastWithdrawTimestamp;

    constructor(uint amount){
        owner = _msgSender();
        _mint(owner, amount);
    }

    /**
     * @dev See {IPeriodVestingPlan-createVestingPlan}.
     */
    function createVestingPlan(
        address to,
        uint256 amount,
        uint256 planStartAt,
        uint256 period,
        uint256 releaseCount,
        uint256 perPeriodReleaseAmount
    ) external virtual override returns(bool){
        require(to != address(0), "PVERC20: beneficiary should not be the zero address");
        require(amount > 0, "PVERC20: amount should > 0");
        require(period > 0, "PVERC20: period should > 0");
        require(releaseCount > 0, "PVERC20: releaseCount should > 0");
        console.log("start at %s, block.timestamp %s", planStartAt, block.timestamp);
        require(planStartAt > block.timestamp, "PVERC20: plan should start at after right now");
        require(amount == releaseCount * perPeriodReleaseAmount, "PVERC20: amount should equal to releaseCount * perPeriodReleaseAmount");

        address account = _msgSender();
        address vestingPool = address(this);
        VestingPlan memory vestingPlan = VestingPlan({
            from:account,
            to:to,
            amount:amount,
            planStartAt:planStartAt,
            planEndAt:planStartAt + period * releaseCount - 1,
            period:period,
            releaseCount:releaseCount,
            perPeriodReleaseAmount:perPeriodReleaseAmount
        });
        _vestings[vestingPlan.from][vestingPlan.to] = vestingPlan;
        _from_vestings[vestingPlan.from].push(vestingPlan);
        _to_vestings[vestingPlan.to].push(vestingPlan);
        _transfer(account, vestingPool, vestingPlan.amount);
        emit VestingPlanCreated(account, to, amount);
        return true;
    }


    /**
     * @dev See {IPeriodVestingPlan-vestingBalance}.
     */
    function vestingBalance(uint256 atTime) external view virtual override returns(uint256){
        require(atTime >= block.timestamp, "PVERC20: balance check should not check former time point");
        address account = _msgSender();
        return _vestingBalance(account, atTime); 
    }

    function _vestingBalance(address account, uint256 fromNowTo) internal view returns(uint256){
        uint256 last = lastWithdrawTimestamp[account];
        require(last < fromNowTo, "PVERC20: balance check should after last withdraw action");
        uint256 balance;
        VestingPlan[] storage to_account_vestings = _to_vestings[account];

        for (uint i = 0; i < to_account_vestings.length; i++){
            VestingPlan storage v = to_account_vestings[i];
            console.log("now:%s s:%s t:%s", fromNowTo, v.planStartAt, v.planEndAt);
            // plan started and last withdraw do not handle all release tokens.
            if (fromNowTo >= v.planStartAt && last < v.planEndAt){
                uint256 fromNowPeriod = uint256((Math.min(fromNowTo, v.planEndAt) - v.planStartAt + 1) / v.period);
                uint256 lastPeriod = uint256((Math.max(last, v.planStartAt - 1) - (v.planStartAt - 1)) / v.period);
                uint256 newPeriods = fromNowPeriod - lastPeriod;
                balance += newPeriods * v.perPeriodReleaseAmount;
            }
        }
        return balance;
    }


    /**
     * @dev See {IPeriodVestingPlan-withdrawVestingBalance}.
     */
    function withdrawVestingBalance() external virtual override returns (bool){
        address account = _msgSender();
        console.log("before transefer ts: %s", block.timestamp);
        uint256 balance = _vestingBalance(account, block.timestamp);
        _transfer(address(this), account, balance);
        console.log("after transfer ts: %s", block.timestamp);
        lastWithdrawTimestamp[account] = block.timestamp;
        return true;
    }

}

