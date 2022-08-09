// SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract Bank is Initializable, UUPSUpgradeable, OwnableUpgradeable{

    mapping(address => uint) public balances;
    
    function initialize() public initializer{
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function deposit() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint balance = balances[msg.sender];
        require(balance > 0);
        (bool sent,) = msg.sender.call{value:balance}("");
        require(sent,"Failed to send ether");
        balances[msg.sender] = 0;
    }

    function checkBankBalance() public view returns (uint){
        return address(this).balance;
    }
}

