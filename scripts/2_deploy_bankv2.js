const { ethers,upgrades } = require("hardhat");

const bankProxyAddress = '0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63';
const attackProxyAddress = '0x5F7D25eeba4994d0e7927D81cd794436E9963936';

async function main(){
    console.log("Original Bank Contract (proxy) address : ",bankProxyAddress)
    const BankV2 = await ethers.getContractFactory("BankV2")
    console.log("Upgrading to Bank version 2!")
    const bankv2 = await upgrades.upgradeProxy(bankProxyAddress,BankV2)
    console.log("Bank Version 2 (proxy) address [ Must be same ] : ",bankv2.address)
    console.log("Bank Implementation address : ", await upgrades.erc1967.getImplementationAddress(bankv2.address))

    console.log("Original Attack Contract (proxy) address : ",attackProxyAddress)
    const AttackV2 = await ethers.getContractFactory("AttackV2")
    console.log("Upgrading to Attack version 2!")
    const attackv2 = await upgrades.upgradeProxy(attackProxyAddress,AttackV2)
    console.log("Attack Version 2 (proxy) address [ Must be same ] : ",attackv2.address)
    console.log("Attack Implementation address : ", await upgrades.erc1967.getImplementationAddress(attackv2.address))
}

main();