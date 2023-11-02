const A = artifacts.require("SimpleContract");

module.exports = (deployer)=>{
  deployer.deploy(A);
};