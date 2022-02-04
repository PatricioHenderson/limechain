pragma solidity ^0.8.0;

import "./libraryfactory.sol";

contract LibraryRent is LibraryFactory {
    
    mapping(uint => address) public bookToRenter;
    mapping(address => uint) renterBookCount;

    function listAllBooks() public view returns (string[] memory) {
        string[] memory result = new string[](books.length);
        uint counter = 0;
        for (uint i = 0; i < books.length; i++) {
            result[counter] = books[i].name;
            counter++;
        }
        return result;
    }

    function rentBook(uint16 _id) public {
        require(renterBookCount[msg.sender] == 0);
        LibraryFactory.borrowBook(_id);
        
    } 
    function returnBook(uint16 _id) public {
        require(renterBookCount[msg.sender] == 1);
        books[_id].stock++;
    }
    function GetBook(uint16 _id) public view returns (string memory) {
        return books[_id].name;
    }

    
}
