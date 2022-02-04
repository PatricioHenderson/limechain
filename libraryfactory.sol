pragma solidity ^0.8.0;

import "./ownable.sol";

contract LibraryFactory is Ownable {

    event NewBook(string name, string author, uint16 _stock);

    struct Book {
        string name;
        string author;
        uint16 stock;
        uint id;
    }

    Book[] public books;

    function verifyAdministrator(address _admin) public view returns (bool) {
        return (msg.sender == _admin);
    }


    function addNewBook(string memory _name, string memory _author, uint16 _stock) internal  {
        require(verifyAdministrator(msg.sender));
        require(_stock > 0);
        uint id = books.length - 1;
        books.push(Book(_name, _author, _stock, id));
        emit NewBook(_name, _author, _stock);
        
    }

    function borrowBook(uint16 _id) public {
        if (books[_id].stock > 0) {
            books[_id].stock--;
        }
    }
    
    function getBook(uint16 _id) external view returns (string memory, string memory, uint16) {
        return (books[_id].name, books[_id].author, books[_id].stock);
    }

    }
