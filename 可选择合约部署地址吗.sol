//如果合约部署时可以任意选择地址，那么会发生冲突吗？
//如果另一个人拿同样的开源代码部署在同样的地址上，这不就是伪造了吗？


//remix中deploy中的 at address 是用于获取已经部署的合约，不用重复部署的。
//但是还是需要提供源码，用于生成 abi。 abi + address 就可以在js中获得一个链上合约的handler。


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

contract Caller {
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }

    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);  // 这是把合约部署在指定的address上吗？
        callee.setX(_x);
    }

    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}

