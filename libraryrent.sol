pragma solidity ^0.8.0;

import "./libraryfactory.sol";

contract LibraryRent is LibraryFactory {
    mapping(uint => adress) public bookToRenter;
    mapping(adress => uint) public renterBookCount;

    function getAllBooks() public view returns (address[]) {
        return LibraryFactory.getAllBooks();
    }

    function borrowBook(address _book) public payable {
        require(renterBookCount[msg.sender] == 0);
        LibraryFactory.borrowBook(_book);
    } 
    
    function returnBook(address _book, uint _id) public {
        require(bookToRenter[_id] == msg.sender);
        book.stock++;
    }

    function getBook(uint _id) public view returns (address) {
        return LibraryFactory.getBook(_id);
    }
}
