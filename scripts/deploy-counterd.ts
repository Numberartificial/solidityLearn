import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";

async function deploy(){
    const counterd = await ethers.getContractFactory("Counterd");
    const cd = await counterd.deploy();
    await cd.deployed();

    return cd;
}

async function count(cd){
    await cd.count();
    console.log("count", await cd.getCounter());
}

deploy().then(count);