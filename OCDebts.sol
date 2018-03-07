pragma solidity ^0.4.20;

contract OffChainDebts {
    mapping (address => uint) private oneMansDebt;
    
    //x = MyStruct({a: 1, b: 2});
    
    address owner = msg.sender;
    
    event Borrowed(address debtor, uint amountBorrowed);
    event Repayed(address debtor,  uint amountRepayed, uint debtIs);
    event Error(string message);
    
    
    function typeCheck () returns (uint) {
        uint128 a = 1;
        uint128 b = 2 + a +  5;
        return b;
    }
    
    function borrow (uint amountBorrowed) public returns (bool) {
        
        if(msg.sender == owner) {
            Error("Borrowing to yourself is not possible");
            return false;
        }
        if (amountIsValid(amountBorrowed + oneMansDebt[msg.sender])) {
            if(oneMansDebt[msg.sender] + amountBorrowed > 2^256 - 1)
        oneMansDebt[msg.sender] += amountBorrowed;
        Borrowed(msg.sender, amountBorrowed);
        return true;
        }
        Error("Does not work that way! Total debt is greater than unsigned integer256");
        return false;
    }
    
    
    function repay (address debterAddress, uint amountRepayed) public onlyOwner returns (bool)  {
        
                if (amountIsValid(amountRepayed)) {
                    if (amountRepayed <= oneMansDebt[debterAddress]) {
                    oneMansDebt[debterAddress] -= amountRepayed;
                    Repayed(debterAddress, amountRepayed, oneMansDebt[debterAddress]);
                    return true;
                    } else if (amountRepayed > oneMansDebt[debterAddress]) {
                    uint debtWas = oneMansDebt[debterAddress];
                    oneMansDebt[debterAddress] = 0; 
                    Repayed(debterAddress, debtWas, 0);
                    return true;
                    } else {
                    Error("Does not work that way! Pass unsigned integer256 value");
                    return false;
                    }
                }
                Error("Invalid amount");
                return false;
        
    }
    
    
    function checkDebt() public view returns (uint) {
        
        if (oneMansDebt[msg.sender] != 0) {
            return oneMansDebt[msg.sender];
        } 
        Error("No debt for this address");
        
    } 
    
    function amountIsValid(uint amount) private pure returns (bool) {
        if (amount > 0 && amount < 2**256 - 1) {
            //Error("Why this does not work?");
            return true;
        }
        else return false;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}