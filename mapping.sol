// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Mapping {
    // Mapping from address to uint
    // 在address上整数值
    // 账户记账用
    mapping(address => uint) public myMap;


    // 获取存在某个地址上的整数值
    function get(address _addr) public view returns (uint) {
        // Mapping always returns a value.
        // If the value was never set, it will return the default value.
        return myMap[_addr];
    }


    // 这个address与某个用户的账户address重合，会发生什么事情？    
    function set(address _addr, uint _i) public {
        // Update the value at this address
        myMap[_addr] = _i;
    }

    // 从区块链上删除数据吗？或者说是本质上改变数据，改变为0
    function remove(address _addr) public {
        // Reset the value to the default value.
        delete myMap[_addr];
    }
}

contract NestedMapping {
    // Nested mapping (mapping from address to another mapping)
    mapping(address => mapping(uint => bool)) public nested;


    // address是一级key，uint是二级key，获取一个bool值
    function get(address _addr1, uint _i) public view returns (bool) {
        // You can get values from a nested mapping
        // even when it is not initialized
        return nested[_addr1][_i];
    }

    function set(
        address _addr1,
        uint _i,
        bool _boo
    ) public {
        nested[_addr1][_i] = _boo;
    }

    function remove(address _addr1, uint _i) public {
        delete nested[_addr1][_i];
    }
}
