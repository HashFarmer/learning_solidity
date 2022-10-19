//参见：可选择合约部署地址吗.sol


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
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x); //这个_callee必须是Callee的一个部署上链合约的地址
    }

    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        
    }

    function setXandSendEther(Callee _callee, uint _x) public payable {
        (uint x, uint value) = _callee.setXandSendEther{value: msg.value}(_x);
    }
}
