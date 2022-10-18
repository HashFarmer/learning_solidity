//class的instance有实例属性的概念，每一个实例的实例属性是不一样的，各自有各自的实例属性

//但是smart contract的实例，没有实例属性，smart contract的实例更像是一个handler

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
import "./x.sol";

contract Y {
    
    Foo public foo = new X("Jack");
    
    Foo public bar = new X("Joe");
    
    

    // Test Foo.sol by getting it's name.
    function getFooName() public view returns (string memory) {
        return foo.name();
        return bar.name();
    }
}
