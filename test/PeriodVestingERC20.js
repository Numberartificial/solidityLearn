const { ethers } = require("hardhat")
const { expect } = require("chai");

describe("PERC20", function () {
  it("plan", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("PeriodVestingERC20");

    const PVERC20 = await Token.deploy();

    const ownerBalance = await PVERC20.balanceOf(owner.address);
    expect(await PVERC20.totalSupply()).to.equal(ownerBalance);

    now = Math.floor(new Date().getTime() / 1000);
    const created = await PVERC20.connect(owner).createVestingPlan(
      addr1.address, 
      500, 
      now,
      5,
      20,
      25
      );
    const ownerNewBalance = parseInt(await PVERC20.balanceOf(owner.address));
    expect(ownerBalance).to.equal(ownerNewBalance + 500);
    expect(await PVERC20.balanceOf(PVERC20.address)).to.equal(500);

    //test transfer
    expect(await PVERC20.vestingBalance(addr1.address, now + 5)).to.equal(25);
    expect(await PVERC20.vestingBalance(addr1.address, now + 10)).to.equal(50);

  });
});