pragma solidity >= 0.5.0 < 0.7.0 ;


contract NewCurrency {
    
    address public owner ;
    mapping(address => uint) public balances ;
    
    event sent(address from, address to, uint amount);
    
    constructor() public {
        owner = msg.sender;
    }
    
    function mint(address reciever , uint amount) public {
        require(owner == msg.sender,"you are not the owner");
        require(amount <= 1e50,"amount must be greater than 1e50");
        balances[reciever] += amount ; 
    }
    
    function send(address reciever , uint amount) public{
        require(amount <= balances[msg.sender], "not enough balance");
        balances[msg.sender] -= amount;
        balances[reciever] += amount;
        emit sent(msg.sender,reciever,amount);
    }
}