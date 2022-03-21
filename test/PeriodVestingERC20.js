const { ethers } = require("hardhat")
const { expect } = require("chai");

describe("PERC20", function () {
  it("plan", async function () {
    const [owner, addr1, addr2] = await ethers.getSigners();

    const Token = await ethers.getContractFactory("PeriodVestingERC20");

    const hardhatToken = await Token.deploy();

    const ownerBalance = await hardhatToken.balanceOf(owner.address);
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);

    now = Math.floor(new Date().getTime() / 1000);
    const created = await hardhatToken.connect(owner).createVestingPlan(
      addr1.address, 
      500, 
      now,
      5,
      20,
      25
      );
    expect(await hardhatToken.totalSupply()).to.equal(ownerBalance);

    //test transfer
    expect(await hardhatToken.vestingBalance(addr1.address, now + 5)).to.equal(25);
    expect(await hardhatToken.vestingBalance(addr1.address, now + 10)).to.equal(50);

  });
});