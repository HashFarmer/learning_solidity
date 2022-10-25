//class的instance有实例属性的概念，每一个实例的实例属性是不一样的，各自有各自的实例属性，而且还有static属性等公共属性

//但是smart contract的实例，只有实例属性，没有公共属性的概念，没有static的概念

//在js代码中，smart contract的实例仅仅是一个handler，因为一个smart contract必须有自己的地址

=========== x.sol ==========================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

=========== y.sol ===========================

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import Foo.sol from current directory
import "./21_x.sol";

contract Y {
    
    X public foo = new X("Jack");
    
    X public bar = new X("Joe");
    
    // foo, bar 被自动部署到两个不同地址了，这就是storage的作用了吧，如果foo，bar做为局部变量或函数参数情况会怎样？
    // 完全没有公共属性（static）的概念
    
    function getName1() public view returns (string memory) {
        return foo.name();  
    }

    function getName2() public view returns (string memory) {
        return bar.name();
    }

}
