# bosonMarketPlace

The Problem:
Create a physical item marketplace where sellers may sell items and buyers may buy the items for sale. These transactions are stored in escrow until the buyer indicates that they have received their order. Once the order is manually certified, the escrowed funds are released to the seller of said item.

Success Criteria:
Create an item - (The seller must be able to create an item to sell on the marketplace)
Items for sale List - (The buyer must be able to view the items for sale)
Place order - (The buyer must be able to place an order for an item for sale)
Escrow Non-Completed Orders - (The buyer protects their money by escrowing/locking up funds. Once they receive their item, they will release funds to the seller)
Refund Complaints - (If the buyer complains, the order will be canceled and their funds will be returned)
Complete Orders - (If the buyer marks the order as complete, the escrowed funds are released to the seller)

The Solution:
Create a marketplace token + monitor balances
I created a marketplace token that is denominated in wei (1 wei = 1 token)
When a user wants to place orders or receive payment for sold items, they must transact with this token.
A user can use the addToBalance() method to transfer wei and the transacted wei will be added to the address mapping balances().
Sellers create an item on the marketplace
Sellers use the sellItem() method, insert the title of the item and the price as params, and the item will be added to the items array with the msg.sender as the item owner.
Buyers can view items for sale
Buyers can call the items() array and pass the item index as a param to view the items for sale
Buyers can place an order on an item for sale
Buyers can use the buyItem() method and pass the item’s index position within the items array.
If your balance is greater than the price of an item, then the method will update your balance in proportion to the price of the item and create an order that indicates the order’s title, price, seller, and buyer.
Escrow non-Completed Orders
The escrow value is held within the order itself once an order is placed. For example, if I buy a t-shirt worth 10 wei, my account balance will be deducted by 10. If I choose to be refunded, the refund amount will be calculated by the order’s price.
The order will be marked inactive or complete within the function call to halt any double-spend attacks. This is because the completeOrder() or complainRefund() methods require the order’s booleans to have a certain state. Explained later
Refund seller if they complain
If a seller would like a refund, they use the complainRefund() method and pass the index of the order from the orders() array.
If the order has not already been completed or if a refund has not already been issued for this order and the seller is the msg.sender, update their balance by adding the price of the item to their balance.
The order should be marked as inactive to stop the seller from recalling the function.
Pay seller once the order is marked as paid
 Once the buyer receives their order, they call the completeOrder() method and pass the index of the order from the orders() array.
If the order has not already been completed or if a refund has not already been issued for this order and the seller is the msg.sender, update the buyer balance by adding the price of the item to their balance.
Withdraw from account balance
Once a user wants to cash out of the market place, they use the withdrawFromBalance() method and pass the wei they would like to withdraw.
If their balance is larger than the amount of wei they are looking to withdraw, the function transfers the wei param to the msg.sender’s address.
How to run the solution (REMIX)
Visit Remix
Create a new file
Copy and paste contractfileName.sol into Remix file
Compile Code
Click Deploy (Javascript VM)
Utilize Javascript UI to interact with contract

Testing - Core Functionality
Add to balance - Should add to accounts balance mapping
Create Item - Should create an item and push it to the items array
Place order - Should create order and push it to orders array
Refund order - Should add order price to buyer’s balance
Complete order - Should add order price to seller’s balance
Withdraw money - Should transfer money to accounts address and decrease accounts balance by transfer amount
How to run test
Create a folder for the project on the desktop.
Command center
Go into the folder
Run truffle init to create files(Download Truffle)
Open entire project in atom
Set up the project in Atom ()
Copy and past file names from Github into Atom
Test in command center
Truffle test
