// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Bank {
    // 不需要是数组就可以存储多个账户
    // 类比与python中的dict类型
    mapping(address => uint) public Balance;

    function get_user_number() public returns(uint){
        return Balance.;
    }

    function user_deposit() public payable {
        Balance[msg.sender] = msg.value;
    }

    function get_user_banlance(address _addr) public view returns (uint) {
        return Balance[_addr];
    }

    function remove(address _addr) public {
        // Reset the value to the default value.
        delete Balance[_addr];
    }
}
