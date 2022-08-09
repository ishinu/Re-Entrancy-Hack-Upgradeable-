// SPDX-License-Identifier:MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract BankV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable{

    mapping(address => uint) public balances;

    bool internal locked; // Wonder that we added new state variable after the existing ones to prevent storage clashes.

    modifier noReentrant(){                                 // 2. Modifier to lock the re-entrant check with boolean.
        require(!locked,'No reentrancy allowed');
        locked = true;
        _;
        locked = false;
    }
    
    function initialize() public initializer{
        __Ownable_init();
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function deposit() public payable{
        balances[msg.sender] += msg.value;
    }

    function withdraw() public noReentrant {
        uint balance = balances[msg.sender];
        require(balance > 0);
        balances[msg.sender] = 0;                           // 1. Perform operation on state variables befores external calls.
        (bool sent,) = msg.sender.call{value:balance}("");
        require(sent,"Failed to send ether");
    }

    function checkBankBalance() public view returns (uint){
        return address(this).balance;
    }
}

