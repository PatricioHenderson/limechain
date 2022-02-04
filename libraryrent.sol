pragma solidity ^0.8.0;

contract Library {
    struct Book {
        string name;
        string author;
        uint stock;
    }

    struct Rent {
        bool now;
        bool ever;
    }

    Book[] private books;
    address public owner;
    mapping (uint => address[]) public everRentingUsers;
    mapping (uint => mapping (address => Rent)) public rents;

    modifier onlyOwner() {
        require(owner == msg.sender, 'CALLER_IS_NOT_OWNER');
        _;
    }

    modifier onlyExistingBook(uint id) {
        require(id < books.length, 'BOOK_DOES_NOT_EXIST');
        _;   
    }

    event BookAdded(uint indexed id, string name, string author, uint stock);
    event BookBorrowed(uint indexed id, address indexed user);
    event BookReturned(uint indexed id, address indexed user);

    constructor() {
        owner = msg.sender;
    }

    function addBook(string memory name, string memory author, uint stock) external onlyOwner returns(uint id) {
        require(stock > 0, 'STOCK_ZERO');
        id = books.length;
        books.push(Book(name, author, stock));
        emit BookAdded(id, name, author, stock);
    }

    function borrowBook(uint id) external onlyExistingBook(id) {
        Book storage book = books[id];
        require(book.stock > 0, 'NO_AVAILABLE_COPIES');

        Rent storage rent = rents[id][msg.sender];
        require(!rent.now, 'USER_ALREADY_RENTED_BOOK');
        
        book.stock--;
        rent.now = true;
        emit BookBorrowed(id, msg.sender);

        if (!rent.ever) {
            rent.ever = true;
            everRentingUsers[id].push(msg.sender);
        }
    }
  
    function returnBook(uint id) external onlyExistingBook(id) {
        Rent storage rent = rents[id][msg.sender];
        require(rent.now, 'USER_HAS_NOT_RENTED_BOOK');
        
        books[id].stock++;
        rent.now = false;
        emit BookReturned(id, msg.sender);
    }
}
