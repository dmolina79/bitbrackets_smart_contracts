# README #

Download truffle v4.1.0 or up
https://github.com/trufflesuite/truffle/releases

npm install -g truffle

Download ganache client
http://truffleframework.com/ganache/

* Quick summary
Repository for BitBrackets Smart Contracts repositories
0.0.1

### How do I get set up? ###

*Working with Truffle
cd into your working directory.
From there, you can run truffle compile, truffle migrate and truffle test to compile your contracts, deploy those contracts to the network, and run their associated unit tests.

* How to run tests
truffle test

* Project uses Open Zepellin Contracts
https://github.com/OpenZeppelin/zeppelin-solidity

### Deployment instructions ###

* Download and install Geth (https://geth.ethereum.org/downloads/)
* The folder **./private_network** contains all the data and commands for the private network.

* #### 1 - Configure your Private Network ####
    * Run the file **1_config** located in **private_network** folder.
* #### 2 - Start Geth ####
    * Run the file **2_start_geth** located in **private_network** folder.
* #### 3 - Attach Geth to your Private Network ####

In order to can deploy our smart contract into Geth, we need to start mining in our private network. To do that, first we need to create an account and unlock it following these steps.

* In a new console run the file ***3_attach_geth*** located in ***private_network*** folder.
    * It will show you a *Geth Console* with *>* prompted. 
        * You need to create a new account typing **personal.newAccount()** command. It will ask you for a password. Or you can type **personal.newAccount("password")** command.
        * Once you press enter and type the password, it will show you your new address.
        * Now we have to unlock the new account, in order to mine in our private network. To do so, type the **personal.unlockAccount(eth.accounts[0])** command. It will ask you the password you wrote before.
        * Finally, we can start mining. Type: **miner.start(1)**. After that you will see the message ***Update mining threads*** in the first console we opened.
* The last step is deploy our contracts. Now we need to open a new console, and type **truffle migrate --reset --network geth**.

### Deployment to Testnets or Mainnet ###

In order to can deploy the smart contracts to testnets (Rinkeby, Kovan, or Ropsten), mainnet, or infura net using the Infura service, you need to configure some parameters.

To do that, it needs to create a ``.env`` file in the root folder with some key/values.

```
INFURA_KEY="INFURA_KEY"
GAS_PRICE_GWEI_KEY="20"
GAS_WEI_KEY=4600000
MNEMONIC_KEY="mnemonic 12 phrases"
ADDRESS_COUNT_KEY=3
```

The **optional** key/values are:
```
GAS_PRICE_GWEI_KEY="20"
GAS_WEI_KEY=4600000
ADDRESS_COUNT_KEY=3
```
If some of them are not defined in ``.env``, the process will take those values by default.

### How get JSON sample with events info. ###

There is a test file named ```./test/ContestPoolFactoryCreateEventsDataTest.js```. To generate events data, you need to run that file using the command line:
```truffle test ./test/ContestPoolFactoryCreateEventsDataTest.js```

After executing the test, it will create an ```events.json``` file in the root folder. That file will contains all events data.

### Contribution guidelines ###

* Writing tests
* Code review
* Other guidelines

Using Solium for Linter Solidity https://github.com/duaraghav8/Solium

### Who do I talk to? ###

* Repo owner or admin
Slack

### TODO List ##

* DONE  Add require to avoid creating ContestPools if Contest definition time has passed
* PENDING   (It could be invoking factory.definitions('ContestName')) Add view method to Factory to query existing definitions
* DONE  Add methods to Factory to disable/modify/delete existing Contest Definitions 
* Fix warnings in smart contracts.
* DONE  Add authors in test files (equals to smart contract files).
* Add LICENSE file in root folder.
* Check passwords/users/other information before moving to "official" repository.
* Check README file.
* Check if the event LogPublishedScore in ContestPool is needed. It contains a LogNewHighScore event.