const { ethers, upgrades } = require("hardhat");

async function main(){
    const Bank = await ethers.getContractFactory("Bank");
    console.log("Deploying Bank contract...");
    const bank = await upgrades.deployProxy(Bank, { 
        initializer : "initialize",
    });
    await bank.deployed();
    console.log("Bank(proxy) address : ",bank.address);
    console.log("Bank Implementation address via (getImplementationAddress) : ",await upgrades.erc1967.getImplementationAddress(bank.address));

    const Attack = await ethers.getContractFactory("Attack");
    console.log("Deploying Attack contract...");
    const attack = await upgrades.deployProxy(Attack, [bank.address],{
        initializer : "initialize",
    });
    await attack.deployed();
    console.log("Attack(proxy) address : ",attack.address);
    console.log("Attack Implementation address via (getImplementationAddress) : ",await upgrades.erc1967.getImplementationAddress(attack.address));
}

main();