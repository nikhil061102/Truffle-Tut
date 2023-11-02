# Truffle Install 
Check latest version of node, npm and nvm, then to install truffle and check its version
```
npm install -g truffle 
truffle version
```
# Initiating Project in Truffle
In terminal, write :-
```
truffle init
```
# Compiling Smart Contracts in Truffle
Check in `truffle-config.js` in `compilers` to verify right version of compiler for your code
```
truffle compile
```
Then a `build` folder is formed
Note "all" the contracts and compiled at once in this method 

# Deploy Contracts

Write a migration file. A simple migration file looks like this:

Filename: 4_example_migration.js
```
const contract = artifacts.require("SimpleContract");

module.exports = function(deployer) {
  deployer.deploy(contract);
};
```
Note that the filename is prefixed with a number. It is not mandatory. But since the contracts are migrated by alphabetical order in the migrate folder, so we add the numbered prefix to migrate them in a particular order which we wish (since some contracts depend on prev. contracts so a particular order is needed.)

Additional points for `deployer` :-

Deploying multiple contracts in one file. If you want a particular order (say second one is inherited contract). 
```
var ContractOne = artifacts.require("ContractOne");
var ContractTwo = artifacts.require("ContractTwo");

module.exports = function(deployer) {
  deployer.deploy(ContractOne);
  deployer.deploy(ContractTwo);
};

// First 'ContractOne' is deployed then 'ContractTwo' is deployed
```
Alternatively, each function on the deployer can be used as a Promise, to queue up deployment tasks that depend on the execution of the previous task:
```
// Deploy A, then deploy B, passing in A's newly deployed address
deployer.deploy(A).then(()=>{
  return deployer.deploy(B);
});
```
Using async/await syntax:
```
module.exports = async function(deployer) {
  // deploy a contract
  await deployer.deploy(MyContract);
  //access information about your deployed contract instance
  const instance = await MyContract.deployed();
}
```
Deploy with constructor arguments or some additional arguments
```
// Deploy a single contract with constructor arguments
deployer.deploy(A, arg1, arg2, ...);

// Don't deploy this contract if it has already been deployed
deployer.deploy(A, {overwrite: false});

// Set a maximum amount of gas and `from` address for the deployment
deployer.deploy(A, {gas: 4612388, from: "0x...."});
```

`accounts` and `network` are also available for use. 
```
module.exports = (deployer, network, accounts)=>{
  // console.log(accounts);
  if (network == "live") {
    deployer.deploy(A, {from: accounts[0]});
  } else {
    deployer.deploy(A, {from: accounts[3]});
  }
}
```

Change in `truffle-config.js` in `development` in `networks`. Change `port` to whatever in Ganache GUI
```
truffle migrate
```
By default, `truffle migrate` will also run `truffle compile`.

If you change your sol files and truffle migrate, the changes will not be reflected in compilation so to recompile properly, you need to use this command.
```
truffle migrate --reset
```

# Infura - deployment made easy
#### (You can also use Alchemy or others😋)

Change in `truffle-config.js` in `goerli` in `networks`. Change `goerli` to whatever you want to use. Also change network_id for your network. (For Sepolia as example : network_id: 11155111)

Notice that there is `MNEMONIC` and `https://goerli.infura.io/v3/${PROJECT_ID}` written there.

Scroll up and you'll see 
```
require('dotenv').config();
const { MNEMONIC, PROJECT_ID } = process.env;

const HDWalletProvider = require('@truffle/hdwallet-provider');
```
Uncomment this and then npm install 
```
npm install dotenv
npm install @truffle/hdwallet-provider
```
Create a new .env file (to keep the private variables secret) and write `MNEMONIC` & `PROJECT_ID`
* MNEMONIC is your 12 phrase mnemonic
* PROJECT_ID = Your Infura project link or something like this. There are mostly two types of links Https or WebSockets (wss). You can use any. In case the Https one gives error, use wss one.

Then you can migrate using your testnet (sepolia in my case) using Infura or whatever you are using. You can find your link of deployed contract using etherscan for your particular testnet.
```
truffle migrate --network <your testnet> --reset
For eg :- truffle migrate --network sepolia --reset
```
`Pausing for 2 confirmations...` is seen because in `truffle-config.js`, in network/sepolia/confirmations we have mentioned `confirmations: 2`.

You can check this contract address on etherscan using transaction hash or contract address.


# Use Truffle Develop and Console
Both Truffle Develop and console provide most of the features available in the Truffle command line tool. For instance, you can type `migrate --reset` within the console, and it will be interpreted the same as if you ran `truffle migrate --reset`

### Difference in `console` and `develop`. 

#### Console 
* If you mention any test network then, connect to that network. Else if not mentioned then connects to Ganache (but if ganache is not running, gives error)
* This reads from `development` from `networks` in `truffle-config.js`. (Infact normal deployment also reads from same.) So, in case of default (Ganache), the port needs to be right so it is reading from correct port otherwise error.
* You have a client you're already using, such as Ganache or geth (default if no network mentioned)
* You want to migrate to a testnet (or the main Ethereum network) For example : `truffle console --network sepolia`.
* You want to use a specific mnemonic or account list. Using :- `truffle console --mnemonic "your custom mnemonic phrase here"` or `truffle console --accounts "0xPrivateKey1,0xPrivateKey2,0xPrivateKey3"`

#### Develop 
* You can configure your network acc. to need.
* This reads from `develop` from `networks` in `truffle-config.js`.
* Some sections in `develop` from `networks`
    * _host_ : The hostname to listen on. Defaults to "127.0.0.1". 
    * _port_ : The port to listen on. Defaults to 9545. 
    * _network_id_ : The network ID to use. Defaults to 5777.
    * _accounts_ : The number of unlocked accounts Ganache should provide. Defaults to 10. Alias: total_accounts.
    * _defaultEtherBalance_ : The default amount of ether to seed unlocked accounts with, specified in ether. Defaults to 100 ether. Alias: default_balance_ether
    * _blockTime_ : If specified, the number of seconds inbetween mining blocks (as opposed to automatically mining on each transaction sent). Defaults to 0 (i.e., automine).
    * _gasLimit_ : The block gas limit. Defaults to 6721975.
    * _gasPrice_ : The gas price, specified in wei. Defaults to 2000000000 wei.
    * _time_ : The genesis time. Alias: genesis_time.
* You are testing your project with no intention of immediately deploying
* You don't need to work with specific accounts (fine with using any default development accounts)

Some sample code to try in terminal for `console` or `develop`.
```
const contract = await SimpleContract.deployed()
contract.address
const data = await contract.num()
const data2 = await contract.getNum()
data2 OR data2.toString()
await contract.setNum(37)
```