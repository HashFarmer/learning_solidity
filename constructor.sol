// constructor 可有可无
// 它的作用就在于可以用“自定义”的方式去实例化一些contract
// 与contract同名的函数是不允许的，
// SyntaxError: Functions are not allowed to have the same name as the contract. 
// If you intend this to be a constructor, use "constructor(...) { ... }" to define it.


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Base contract X
contract X {
    string public name;

    //SyntaxError: Functions are not allowed to have the same name as the contract. 
    //If you intend this to be a constructor, use "constructor(...) { ... }" to define it.
    function X(string memory _name) public{
        name = _name;
    }
}

// Base contract Y
contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

contract Z {
    string public text;

    X public x ;
    X public x2 = X("xxx"); //TypeError: Explicit type conversion not allowed from "literal_string "xxx"" to "contract X".
    Y public y = new Y("yyy");
    Y public y2 = Y("yyy222"); //TypeError: Explicit type conversion not allowed from "literal_string "yyy222"" to "contract Y".
}
