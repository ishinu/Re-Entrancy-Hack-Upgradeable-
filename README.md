# Re-Entrancy Hack

## Bank Contract with Attack Contract ( UUPS Upgradeable *BOTH* )

### Terminal commands to make it [ Compile-Ready ]

- git clone `https://github.com/ishinu/Re-Entrancy-Hack-Upgradeable-` and run `npm install`
- `npx hardhat compile` and that's it! 

## To Deploy on Ropsten Etherscan network

### Pre-requisites : 

- Make an .env file in your code editor
- Make an account on etherscan and get the API key ( eg : `B1QX12KTQITUSU1233VR6M12MMCX6Q123K2` [not mine] ) 
- Make an account on INFURA and get the API key ( eg :`e395b912f212337123cb3f938b123b18` [just an eg] )
- Hope you have metamask, don't use main account, make a test account and get some ropsten Eth from `https://faucet.metamask.io/` and copy the private key of your test account just created. 

Your .env file shall look like this : 

```
PRIVATE_KEY=12341234xxx
ETHERSCAN_API_KEY=12341234xxx
INFURA_API_KEY=12341234xxx
```

You are deploy ready on Ropsten public testnet! 

### Terminal commands to make it [ Deploy-Ready ]

- `npx hardhat compile`
- `env $(cat .env) npx hardhat run --network ropsten scripts/deploy_bank_v1.js`

Example of what shall appear after this command. ( and which address you need to input in next command ) 

```
Deploying Bank contract...
Bank(proxy) address :  0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63
Bank Implementation address via (getImplementationAddress) :  0x716fb814F40b7535C23E42aFE467AE58397D3653
Deploying Attack contract...
Attack(proxy) address :  0x5F7D25eeba4994d0e7927D81cd794436E9963936
Attack Implementation address via (getImplementationAddress) :  0x191A94e045B442179fbc1f633A6D47745F587ca6
```


- `env $(cat .env) npx hardhat verify --network ropsten 0x716fb814F40b7535C23E42aFE467AE58397D3653`

Go to Ropsten etherscan and move to 0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63 address information. 
Search for 'is this a proxy ?', click on it, click on save.
You just verified bank contract proxy, now we have to do same for Attack contract since we have made Attack contract also, an upgradeable contract just like bank.
You make try yourself or follow below command. ( replace the address below with yours' it's just my example for your understanding )

- `env $(cat .env) npx hardhat verify --network ropsten 0x191A94e045B442179fbc1f633A6D47745F587ca6`

Go to Ropsten etherscan and move to 0x5F7D25eeba4994d0e7927D81cd794436E9963936 address information. 
Search for 'is this a proxy ?', click on it, click on save.

One more step!

Hope you remember, upgradeable contracts can't have constructor due to which we replaced our Attack contract constructor with initialize function. 
Now we have to manually call initialize function (write) by going to etherscan attack implementation and initialize with bank implementation address.

Go to 0x191A94e045B442179fbc1f633A6D47745F587ca6 on ropsten etherscan, Click on 'Write contract' and search for your 'initialize' function.
Give it the value , in my case it was 0x716fb814F40b7535C23E42aFE467AE58397D3653 and submit.

Now you have verified Bank and Attack contract proxy! Great!

( Make sure you perform *Transactions* through *Proxy* and NOT the *Implementation* address since storage slots of implementation is not used, instead
in UUPS proxy, storage slots of proxy contract is used and logic calls are performed through implementation contract ) 

### You can test by making transactions and *hacking* / *getting back test ethers* through your attack contract!


```
Any queries if you get, i may assist you : 
Feel free to mail me : tysmgroups@gmail.com
            ~Happy Coding!~
```

# Part 2

## Upgrading to Prevent Re-entrancy

Solved the Re-Entrancy by making few necessary changes in BankV2.sol : 

- First Way : Added a state variable ( bool ) to lock the Re-Entrancy until the executiion of external call finishes.
- Second Way : Decrease the balance of user before external calls still entrancy will work but with less damage. 

### Terminal commands to delpoy Version-2

- `npx hardhat compile`
- `env $(cat .env) npx hardhat run --network ropsten scripts/2_deploy_bankv2.js`

```
Original Bank Contract (proxy) address :  0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63
Upgrading to Bank version 2!
Bank Version 2 (proxy) address [ Must be same ] :  0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63
Bank Implementation address :  0x716fb814F40b7535C23E42aFE467AE58397D3653
Original Attack Contract (proxy) address :  0x5F7D25eeba4994d0e7927D81cd794436E9963936
Upgrading to Attack version 2!
Attack Version 2 (proxy) address [ Must be same ] :  0x5F7D25eeba4994d0e7927D81cd794436E9963936
Attack Implementation address :  0x191A94e045B442179fbc1f633A6D47745F587ca6
```

Bank version 2 contract verification.

- `env $(cat .env) npx hardhat verify --network ropsten 0xf5d8CB0b58b328dff44Bfb02E1a1FEc64C126702` 

Go to Ropsten etherscan and move to 0x63dD81802f049A9d8aEA2Dc8083A24d2915c8e63 address information. 
Search for 'is this a proxy ?', click on it, click on save.
Your proxy is now pointing to the new implementation!

Similarly for the Attack contract since earlier one was importing the previous Bank contract, Newer one ( AttackV2 ) is importing BankV2.

*Mistake by me* : Instead of adding a new state variable in BankV2 contract, for BankV2 import, i removed the earlier one and renamed due to which
storage clashes happened. Always add new state variables after the existing ones.

Proceeding to upgrade the attack contract, first verify the AttackV2 contract code.

- `env $(cat .env) npx hardhat verify --network ropsten 0x3a6693159aB0616c00cA6bFa145A3c1Ee4b223A5`

Afterwards going to initialize function in 0x3a6693159aB0616c00cA6bFa145A3c1Ee4b223A5 in ropsten etherscan and providing value of 0xf5d8CB0b58b328dff44Bfb02E1a1FEc64C126702.

And finally to Ropsten etherscan and move to 0x5F7D25eeba4994d0e7927D81cd794436E9963936 address information. 
Search for 'is this a proxy ?', click on it, click on save.

Done!
Saved :) 




