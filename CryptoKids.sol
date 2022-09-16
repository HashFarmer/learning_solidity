// SPDX-License-Identifier: Unlicensed

// https://www.youtube.com/watch?v=s9MVkHKV2Vw&list=PL3-V86YgFEXSZev5HFjgYe5fcKeUPeqb_&index=2

pragma solidity ^0.8.7;

contract CryptoKids {
    // owner
    address owner;
    
    constructor(){
        owner = msg.sender; //msg.sender is the caller, as for contract ,it is the deployer.
        
    }
    
    //mapping is dictionary in python
    //mapping(string => uint) public kids; // kids['string'] = uint; shouldn't it be mapping(address => uint) ?
    
    // does it consume gas?
    struct Kid{
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
        
    }
    
    Kid[] public kids;
    
    //function without return
    //TypeError: Data Location must be "memory" or "calldata" for parameter in function , but none was given
    //data passed into parameters, either state variables or literal values, or all supplied by caller?
    //why only string values are declared memory?
    //anyone can call this function?
    function addKid(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public {
        // one Kid object is complex, push one Kid into kids
        kids.push(Kid(walletAddress, firstName, lastName, releaseTime, amount, canWithdraw)); 
        // actually amount should be 0 defautly , canWithdraw should be false defautly, should not be set by caller.
    
    }


    //this refers to the contract instance?
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }


    //it is wierd payable function doesn't have a value parameter
    // in this case, the deposit money doesn't go to walletAddress, it goes to the contract instance.
    // walletAddress is useless

    //function deposit(address walletAdress) payable public{}

    //deposit money doesn't go to walletAddress , just goes to contract!!
    //all the deposit money just goes to the contract, kid money is just number
    function deposit(address payable walletAddress) payable public{
        addToKidsBalance(walletAddress);
    }

    // to find the specific kid 
    function addToKidsBalance(address payable walletAddress) private {
        for(uint i = 0; i< kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                kids[i].amount += msg.value;
            }
        }

    }



    function getIndex(address payable walletAddress) view private returns(uint){
        for(uint i = 0; i< kids.length; i++){
            if(kids[i].walletAddress == walletAddress){
                return i;
            }
        }
        return 999;
    }

    // kid checks if able to withdraw
    function availableToWithdraw(address payable walletAddress) public returns(bool){
        uint i = getIndex(walletAddress);
        if(block.timestamp > kids[i].releaseTime){
            kids[i].canWithdraw = true;
            return true;
        } else {
            return false;
        }
    }


    // withdraw money
    // can not withdraw, addKid "amount" worngly input bigger than 0
    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        require(msg.sender == kids[i].walletAddress, "you must be the kid ");
        require(kids[i].canWithdraw == true,"your are not able to withdraw at this time");
        kids[i].walletAddress.transfer(6000000000000000000);
    }



}
