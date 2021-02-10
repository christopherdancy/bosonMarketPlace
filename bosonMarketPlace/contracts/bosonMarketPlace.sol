pragma solidity ^0.5.3;

contract bosonMarketPlace {

    // Stuct - Item is bought
    // and sold on the marketplace
    // included is the itemId, itemTitle
    // the price and the sellers address
    struct item {
        string title;
        uint price;
        address seller;
    }

    // an array of items that
    // will be sold on marketplace
    item[] public items;

    //mapping keeps track of address balances
    //buyers will use this balance to make purchases
    //sellers will track account balances with this mapping
    //add to account???
    mapping(address => uint256) public balances;

    //Struct - order keep an acccount
    //of transactions/escrow on the blockchain
    //and it tracks order status and market particpants
    struct order {
        string title;
        uint price;
        bool completedStatus;
        address seller;
        address buyer;
        bool active;
    }

    // an array or orders
    //that will be tracked on marketplace
    order[] public orders;

    //escrow balance
    //maintain a record of
    //the escrow balance
    uint public escrowBalance = 0;


    //function adds to addresses balance
    //Marketplace stores ethereum value and
    //denomantes prices in wei.
    //a market particpants buys and sells
    //with this market token
    function addToBalance()
        public
        payable{
        require(msg.value>0);
            //transfer ether value and
            //update balance
            balances[msg.sender] = balances[msg.sender] + msg.value;
    }


    //allow a marketplace seller to create an event
    //push this created item to the items array
    //to keep track of items for sale
    function sellItem(string memory _title, uint _price)
        public {
            //push created item to items array
            items.push(item(_title,_price, msg.sender));
    }

    //buyer must use marketplace token (balance)
    //to buy seller's item.
    //function creates an order and
    //the order acts as the escrow balance
    function buyItem(uint _itemNumber)
        public {
            require(balances[msg.sender] >= items[_itemNumber].price);

            //update account balances
            balances[msg.sender] = balances[msg.sender] - items[_itemNumber].price;

            //lock payment in escrow
            orders.push(order(items[_itemNumber].title,items[_itemNumber].price, false,items[_itemNumber].seller, msg.sender,true));
            //update escrow balances
            escrowBalance = escrowBalance + items[_itemNumber].price;

    }

    //buyer recieves refund
    //if buyer complains
    //refund buyers money if function
    //is called
    function complainRefund(uint _orderNumber)
        public {
            //require function revert if
            //the order is complete
            //the buyer is not the sender
            //the order is not active
            require(orders[_orderNumber].completedStatus != true);
            require(orders[_orderNumber].buyer == msg.sender);
            require(orders[_orderNumber].active == true);

            //inactivate the order
            //increase buyer balance by price
            //price was held in escrow
            orders[_orderNumber].active = false;
            balances[msg.sender] = balances[msg.sender] + orders[_orderNumber].price;

            //update escrow balances
            escrowBalance = escrowBalance - orders[_orderNumber].price;
    }

    //seller recieves payment
    //if buyer marks order as complete
    //locked up money sent to seller
    //if function is called

    function completeOrder(uint _orderNumber)
        public {
            //require function revert if
            //the order is complete
            //the buyer is not the sender
            //the order is not active
            require(orders[_orderNumber].completedStatus != true);
            require(orders[_orderNumber].buyer == msg.sender);
            require(orders[_orderNumber].active == true);

            //inactivate the order
            //increase buyer balance by price
            //price was held in escrow
            orders[_orderNumber].active = false;
            orders[_orderNumber].completedStatus = true;
            balances[orders[_orderNumber].seller] = balances[orders[_orderNumber].seller] + orders[_orderNumber].price;

            //update escrow balances
            escrowBalance = escrowBalance - orders[_orderNumber].price;
    }

    function withdrawFromBalance(uint _weiWithdraw)
        public{
            //require withdrawer has enough to withdraw
            require(balances[msg.sender] >= _weiWithdraw);

            //update balances
            balances[msg.sender] = balances[msg.sender] - _weiWithdraw;

            //transfer ether from account
            msg.sender.transfer(_weiWithdraw);
        }


}
