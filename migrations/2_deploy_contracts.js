const Controller = artifacts.require("./control.sol")

module.exports = function(deployer) {
    deployer.deploy(Controller);
};