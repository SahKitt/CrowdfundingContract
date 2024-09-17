const Crowdfunding = artifacts.require("Crowdfunding");

module.exports = function(deployer) {
    const goal = web3.utils.toWei("10", "ether"); // Set goal to 10 ETH
    const duration = 7 * 24 * 60 * 60; // Set duration to 1 week
    deployer.deploy(Crowdfunding, goal, duration);
};
