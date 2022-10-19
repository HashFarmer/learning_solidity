// 分两种情况，
// 一、你知道要交互合约的源码和地址
// 参见：可选择合约部署地址吗.sol
// 二、你只知道要交互的合约的地址，但不知道其源码
//  Call


//============ 25_callee_single.sol =======

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Callee {
    uint public x;
    uint public value;

    function setX(uint _x) public returns (uint) {
        x = _x;
        return x;
    }

    function setXandSendEther(uint _x) public payable returns (uint, uint) {
        x = _x;
        value = msg.value;

        return (x, value);
    }
}


//============== caller.sol ============

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./25_callee_single.sol";

contract Caller {
    // 必须知道 Callee的源码，否则提示 Callee标识符错误
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x); //这个_callee必须是Callee的一个部署上链合约的地址
    }
    // 总结：与一个链上合约交互，（1）必须知道它的源码，（2）必须知道它的合约地址

    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        
    }

    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}
