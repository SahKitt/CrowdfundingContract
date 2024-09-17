// /////import contract
const Crowdfunding = artifacts.require("Crowdfunding");

contract("Crowdfunding", accounts => {
    // //////Test 1
    it("should initialize with the correct goal and deadline", async () => {
        // //interact with contract
        const instance = await Crowdfunding.deployed();
        const goal = await instance.goal();
        // ///convert ether to wei
        assert.equal(goal.toString(), web3.utils.toWei("10", "ether"), "Goal should be 10 ETH");
        const deadline = await instance.deadline(); // retrieve deadline
        assert.isTrue(deadline.toNumber() > 0, "Deadline should be set");//javascript number
    });

    // ///Test 2
    it("should allow contributions", async () => {
        // /////interact with contract
        const instance = await Crowdfunding.deployed();
        // ///conversion ether-wei
        await instance.contribute({ value: web3.utils.toWei("1", "ether"), from: accounts[1] });//Contribute 1 Ether
        const totalRaised = await instance.totalRaised(); //ensure 1 ether is contributed
        assert.equal(totalRaised.toString(), web3.utils.toWei("1", "ether"), "Total raised should be 1 ETH");
    });
});
