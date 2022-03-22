// SPDX-License-Identifier: MIT
// Numberartificial Contracts (last updated v0.0.1)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the periodic vesting plan, main use case is to periodically release(transfer)
 * creator's tokens to beneficiary, then beneficiary can withdraw these released tokens into account.
 *
 * Note `creator account -> Vesting plan created -> periodic released -> vesting balance 
 * -> withdraw -> beneficiary account` is the main work flow, and all actions
 * are serial without parallel according to ethereum system run time, 
 * one can only create vesting plan start at after right now
 * (and any happended withdraw is before this time, so one can withdraw all possible balance 
 * at any time from all possible legal vesting plan).
 */
interface IPeriodVestingPlan{


    /**
     * @dev Sets `amount` as the vesting plan amount of `to` over the caller's tokens.
     * This plan is a periodic vesting plan which means that plan will start at `planStartAt`,
     * then each `period`, `to` will get `perPeriodReleaseAmount` tokens in {vestingBalance},
     * until `releaseCount` times `period` is done.
     * When this call is successful return true, the vesting plan creator {msg.sender} will decrease
     * `amount` tokens at once, and after `releaseCount` times release, `to` will get
     * `perPeriodReleaseAmount` * `releaseCount` = `amount` {vestingBalance}.
     * 
     * One can use {withdrawVestingBalance} to withdraw these {vestingBalance} to tokens.

     * Note that `planStartAt` , `period` are unix timestamp(sencond), and `planStartAt` should 
     * greater than now timestamp, `period` should greater than 0.
     * `perPeriodReleaseAmount` * `releaseCount` should equal to `amount as above mentioned to 
     * make a redundant check both side.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {VestingPlanCreated} event.
     */
    function createVestingPlan(
        address to,
        uint256 amount,
        uint256 planStartAt,
        uint256 period,
        uint256 releaseCount,
        uint256 perPeriodReleaseAmount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that caller will be
     * allowed to withdraw into origin tokens balance(like ERC20) through {withdrawVestingBalance}
     * which are released periodically according to vesting plans;
     * This is zero by default.
     *
     * This value changes when some peroidic vesting plan release(increase) 
     * or {withdrawVestingBalance} are called(decrease).
     */
    function vestingBalance() external view returns(uint256);

    /**
     * @dev Move all `vestingBalance` to origin tokens.
     * After this call returns true, 
     * caller should be able to check origin tokens balance increase `vestingBalance` amount,
     * and `vestingBalance` will be zero at once(in computable semantic,
     *  this means at this unix timestamp second, tokens balance increased `vestingBalance` amount
     * and `vestingBalance` was cleared)
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {WithdrawVestingBalance} event.
     */
    function withdrawVestingBalance() external returns (bool);


    /**
     * @dev Emitted when `amount` tokens are moved from one account (`from`) 
     * to another (`to`) through a periodic vesting plan.
     *
     * Note that `from` will decrease `amount` tokens at once, and `to` will 
     * get all `amount` tokens into {vestingBalance} according to this vesting plan but
     * not right now.
     */
    event VestingPlanCreated(address indexed from, address indexed to, uint256 amount);

    /**
     * @dev Emitted when the `owner` call {withdrawVestingBalance} to 
     * withdraw all {vestingBalance} = `amount` into account (`owner`) 
     * at `withdrawTS`(unix timestamp with second)
     */
    event WithdrawVestingBalance(address indexed owner, uint256 amount, uint256 withdrawTS);

}