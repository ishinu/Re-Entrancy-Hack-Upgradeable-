const { expect } = require("chai");
const { ethers,upgrades } = require("hardhat");
const { BigNumber } = require("ethers");

describe("Bank", function() { 

    beforeEach('get factories', async function(){
        this.Bank = await ethers.getContractFactory("Bank");
    });

    it("checks the deposit function", async function(){
        const bank = await upgrades.deployProxy(this.Bank,{kind:'uups'});
        await bank.deposit({value:1000000000000000});
        expect(await bank.checkBankBalance()).to.equal(BigNumber.from(1000000000000000));
    });
});