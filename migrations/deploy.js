const Testament = artifacts.require("Testament");
module.exports = function(deployer) {
    deployer.deploy(Greeting);
}