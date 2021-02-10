//Contract Abstraction
const bosonMarketPlace = artifacts.require('bosonMarketPlace');

//call contract name
//call accounts
contract("bosonMarketPlace", (accounts) => {

  //add to balance function
  it("should add to balance", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //test should add to balance
    //cannot access a mapping.
    //look for transaction to complete
    const result = await contractInstance.addToBalance({from: accounts[0], value:10});
    //assert
    assert.equal(result.receipt.status, true);
  })

  //Create item function
  it("should add item to list", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //add item named tshirt that costs 10
    //from current accounts and check
    //if item was pushed to items array
    await contractInstance.sellItem("tshirt", 10, {from: accounts[0]});
    const result = await contractInstance.items(0);
    //assert
    assert.equal(result.seller, accounts[0]);
  })

  //order function
  it("should allow accounts(1) to buy accounts(0) item", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //accounts 0 creates an item
    //have account 1 add to balance
    //allow account 1 to order from account 0
    await contractInstance.sellItem("tshirt", 10, {from: accounts[0]});
    await contractInstance.addToBalance({from: accounts[1], value:10});
    await contractInstance.buyItem(0,{from: accounts[1]});
    const result = await contractInstance.orders(0);
    //assert
    assert.equal(result.buyer, accounts[1]);
  })

  //refund function
  it("should allow accounts(1) to recieve a refund/ set totalEscrow to 0", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //account 0 creates tshirt
    //account 1 buys tshirt
    //account 1 refunds
    //escrow balance reset
    await contractInstance.sellItem("tshirt", 10, {from: accounts[0]});
    await contractInstance.addToBalance({from: accounts[1], value:10});
    await contractInstance.buyItem(0,{from: accounts[1]});
    await contractInstance.complainRefund(0,{from: accounts[1]});
    const result = await contractInstance.escrowBalance();
    //assert
    assert.equal(result, 0);
  })


  //Complete order functionality
  it("should complete order", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //account 0 creates tshirt
    //account 1 buys tshirt
    //account 1 completes orders
    //order marked complete
    await contractInstance.sellItem("tshirt", 10, {from: accounts[0]});
    await contractInstance.addToBalance({from: accounts[1], value:10});
    await contractInstance.buyItem(0,{from: accounts[1]});
    await contractInstance.completeOrder(0,{from: accounts[1]});
    const result = await contractInstance.orders(0);
    //assert
    assert.equal(result.completedStatus, true);
  })

  //withdraw function
  it("should withdraw from balance", async() => {
    //setup
    const contractInstance = await bosonMarketPlace.new();
    //act
    //accounts 1 adds to balance
    //accounts 1 withdraws to balance
    //look for transaction reciept
    await contractInstance.addToBalance({from: accounts[1], value:10});
    const result = await contractInstance.withdrawFromBalance(10,{from: accounts[1]});
    //assert
    assert.equal(result.receipt.status, true);
  })

})
