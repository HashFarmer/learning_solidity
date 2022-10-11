// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Bank {

    struct user {
        uint id;
        address account;
        uint balance;
        uint is_created;
    }

    modifier only_new_user(){
        
        /*
        if( Balance[msg.sender].is_created == 1 ){
            revert("you have created account!");
        }
        */
        require(Balance[msg.sender].is_created == 1, "you have created account!");
        _;

    }



    // 不需要是数组就可以存储多个账户
    // 类比与python中的dict类型
    // 但是mapping没有lenght属性！
    mapping(address => user) public Balance;

    uint user_counter = 0;

    // 应该添加一个modifier，已经创建过账户的人不能再次创建账户
    function create_user() public only_new_user{
        Balance[msg.sender] = user(user_counter++, msg.sender, 0, 1);

    }

    function get_user_number() public view returns(uint){
        return user_counter;
    }

    /*

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
    */
}
