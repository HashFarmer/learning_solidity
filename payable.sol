// 被payable修饰的函数就说明这个函数是财务函数，类似于一个单位里的财务人员



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Payable {
    // Payable address can receive Ether
    address payable public owner;

    // Payable constructor can receive Ether
    // 在部署合约时就可以向合约地址中存入ether
    constructor() payable {
        owner = payable(msg.sender);
    }

    // Function to deposit Ether into this contract.
    // Call this function along with some Ether.
    // The balance of this contract will be automatically updated.
    // 调用这个函数的方法是在VALUE中输入值！好奇怪的调用方法。
    // VALUE这个就是msg.value吧？？！！
    // deposit的钱都是进入合约账户，别的账户操作都是仅有记账意义
    // deposit是资金入口，withdraw是资金出口，中间操作都是记账意义
    // 任何人都可以存入，任何人都可以调用这个函数
    function deposit() public payable {}

    // Call this function along with some Ether.
    // The function will throw an error since this function is not payable.
    function notPayable() public {}

    // Function to withdraw all Ether from this contract.
    // withdrawl函数不需要payable函数修饰
    function withdraw() public {
        // get the amount of Ether stored in this contract
        // this就是合约实例本身
        uint amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable
        // 任何人都可以调用，但是钱都自动给到合约创建者了！没有msg.sender的什么事情
        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
    
    // Function to transfer Ether from this contract to address from input
    // 只要合约中有钱，任何人都可以取钱出来，可以发送给包括自己的任何人
    // 任何人可以把合约里的钱发给任何人
    function transfer(address payable _to, uint _amount) public {
        // Note that "to" is declared as payable
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Failed to send Ether");
    }
}
