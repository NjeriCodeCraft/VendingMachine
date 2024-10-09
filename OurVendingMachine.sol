// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VendingMachine {
    // Define the product struct
    struct Product {
        string name;
        uint price;
        uint stock;
        string image;
    }

    // Define the transaction struct
    struct Transaction {
        address buyer;
        uint productId;
        uint quantity;
    }

    // Mapping of products
    mapping (uint => Product) public products;

    // Mapping of transactions
    mapping (uint => Transaction[]) public transactions;

    // Owner address
    address public owner;

    // Constructor
    constructor()  {
        owner = msg.sender;
    }

    // Function to set product (only owner)
    function setProduct(uint _id, string memory _name, uint _price, uint _stock, string memory _image) public {
        require(msg.sender == owner, "Only owner can set products");
        products[_id] = Product(_name, _price, _stock, _image);
    }

    // Function to add stock (only owner)
    function addStock(uint _id, uint _quantity) public {
        require(msg.sender == owner, "Only owner can add stock");
        products[_id].stock += _quantity;
    }

    // Function to buy product
    function buyProduct(uint _id, uint _quantity) public payable {
        // Check if product exists and has enough stock
        require(products[_id].stock >= _quantity, "Not enough stock");
        require(msg.value >= products[_id].price * _quantity, "Insufficient funds");

        // Update stock and create transaction
        products[_id].stock -= _quantity;
        transactions[_id].push(Transaction(msg.sender, _id, _quantity));

        // Transfer funds to owner
        payable(owner).transfer(msg.value);
    }

    // Function to withdraw Ethereum to owner's address
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw funds");
        payable(owner).transfer(address(this).balance);
    }
}