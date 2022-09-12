// SPDX-License-Identifier: Unlicensed

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
        address walletAdress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
        
    }
    
    Kid[] public kids;
    
    //function without return
    //TypeError: Data Location must be "memory" or "calldata" for parameter in function , but none was given
    function addKid(address walletAdress, string firstName, string lastName, uint releaseTime, uint amount, bool canWithdraw) public {
        // one Kid object is complex, push one Kid into kids
        kids.push(Kid(walletAdress, firstName, lastName, releaseTime, amount, canWithdraw));
    
    }
    
    
    
    
    





}
