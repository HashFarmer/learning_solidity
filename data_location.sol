

//自然法则，根据变量声明的所在地来决定变量的location，为什么还需要coder指明呢？
//难道根据变量的声明地无法唯一决定data location？
//这些所有data location指的都是EVM上的
/* https://betterprogramming.pub/solidity-tutorial-all-about-data-locations-dabd33212471

state variables (declared outside of functions) = in storage by default.

local variables (declared inside the body of a function) = in the stack.

Most of the time, you will not need to use the data location keywords (storage, memory, or calldata), 
because Solidity handles the location by the default rules explained above.

However, there are times when you do need to use these keywords and specify the data location,
namely when dealing with variables of complex types like struct and arrays inside functions.

对局部变量使用storage，结果如下：

struct MyStruct {
        uint foo;
    }
MyStruct struct_s = MyStruct(123);

string string_ss;

function store2() public {
        uint256 storage number2 = 123;
        // TypeError: Data location can only be specified for array, struct or mapping types, but "storage" was given.
        // 不管是memory, 还是 storage, 还是 calldata , 都不行，一样的错误提示
        // 总结：简单类型、局部变量，不需要声明 storage location
        ====
        
        
        MyStruct struct_ss;    // TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.
        uint256[] value;       // TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.
        string string_s ;      // TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.
        // 总结：复杂局部变量，声明必须带location 
        
        MyStruct storage struct_s1;
        MyStruct memory struct_s2;
        MyStruct calldata struct_s3;
        // 总结：只是声明，没有问题的。
        
        
        MyStruct storage struct_1 = MyStruct(123);
        // TypeError: "Type struct DataLocations.MyStruct" memory is not implicitly convertible to expected "type struct DataLocations.MyStruct" storage pointer.
        // memory -> storage pointer , 不可行，是这意思？
        
        MyStruct storage struct_s1 = struct_s; // 做 storage 的局部变量 ，只能做为 state variable 的storage pointer
        
        MyStruct calldata struct_2 = MyStruct(123);
        // TypeError: "Type struct DataLocations.MyStruct" memory is not implicitly convertible to expected "type struct DataLocations.MyStruct" calldata.
        
        MyStruct memory struct_1 = MyStruct(123); // ok
        
        MyStruct struct_1 = MyStruct(123);
        // TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.
        
        // 总结：对于struct，必须声明storage location。
        
        
        uint256[] value; // TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.
        uint256[] storage value_1; // value_1.push(1); 会出错。TypeError: This variable is of storage pointer type and can be accessed without prior assignment, which would lead to undefined behaviour.
        uint256[] memory value_2; // value_2.push(1); 会出错。TypeError: Member "push" is not available in uint256[] memory outside of storage.
        uint256[] calldata value_3; // // value_3.push(1); 会出错。TypeError: Member "push" is not available in uint256[] memory outside of storage.
        
        // 总结：对于数组类型，必须声明storage location，但是三种情况都可行，为什么？
        
        string storage string_s1;
        string storage string_s1 = "abcd"; // TypeError: Type literal_string "abcd" is not implicitly convertible to expected type string storage pointer.
        string storage string_s1 = string_ss; // ok
        
        string memory string_s2;
        string memory string_s2 = "efgh"; // ok
        string memory string_s2 = string_ss; // ok
        
        string calldata string_s3;
        string calldata string_s3 = "xyz"; // TypeError: Type literal_string "xyz" is not implicitly convertible to expected type string calldata.
        string calldata string_s3 = string_ss; // TypeError: Type string storage ref is not implicitly convertible to expected type string calldata.
        // 总结：只是声明，都没有问题
        
        
        

    }
    
    
    function _f( uint[] storage _arr, mapping(uint => address) storage _map, MyStruct storage _myStruct ) 
               internal returns(uint[] memory, mapping(uint => address) storage, MyStruct memory) {
        // do something with storage variables
        return (_arr, _map, _myStruct);
        
    }



//# 这个value仅仅有指针的意义？对value的任何操作都会反映到someData上
contract StoragePointer {
    uint256[] public someData;
    
    function pushToArrayViaPointer() public {
       
        uint256[] storage value = someData;
        value.push(12);
    }
}



//# 以下例子说明，storage声明的local variable只能做为state variable的指针存在
contract MemoryCopy {
    uint256[] public someData;
    constructor() public {
        someData.push(1);
        someData.push(2);
        someData.push(3);
    }

    function doesNotPropagateToStorage() public {
        uint256[] storage storageRef = someData;
        storageRef[0] = 11;

        uint256[] storage storage_local;
        storage_local.push(123);//TypeError，This variable is of storage pointer type and can be accessed without prior assignment, which would lead to undefined behaviour.
        
        //这个memory是指在EVM上吧
        uint256[] memory copyFromRef = storageRef;
        copyFromRef[1] = 22;
    }
}




contract MemoryCopy {
    uint256[] public someData;
    constructor() public {
        someData.push(1);
        someData.push(2);
        someData.push(3);
    }

    function doesNotPropagateToStorage() public {
        uint256[] storage storageRef = someData;
        storageRef[0] = 11;

        uint256[] storage_local; ////TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.

        

        uint256[] memory copyFromRef = storageRef;
        copyFromRef[1] = 22;
    }

    function func1 (uint[] nums) external {   ////TypeError: Data location must be "storage", "memory" or "calldata" for variable, but none was given.

    
    }

}


//一个合约中创建另一个合约的对象，会自动部署到链上
// 有没有那种不部署到链上的合约对象？



貌似"storage", "memory" or "calldata" ，就是为出现函数中的局部变量或函数参数中的动态数据，需要data location声明
When we declare dynamic data types we need to specify the location to store them. 
You must define a data location when using complex data types such as arrays, bytes, and structs. //什么时候需要使用data location关键字

The Ethereum Virtual Machine has 4 areas where it can store items.

1.1 Memory which is used to hold temporary values. It is erased between (external) function calls and is cheaper to use.

ex: h(uint[] memory hArray) internal {}

1.2 Storage which is used to hold permanent values. All the contract state variables will be stored in storage. Every contract has its own storage and it is persistent between function calls and quite expensive to use.

ex: function g(uint[] storage gArray) internal {}

1.3 Calldata: All function calls use calldata, which includes function parameters. Calldata is read-only memory area

1.4 Stack which is used to hold small local variables. It is almost free to use, but can only hold a limited amount of values.

There are defaults for the storage location depending on which type of variable it concerns:

State variables are always in storage
Ex: uint[] storageArray;

Function arguments are always in memory
Local variables of struct, array or mapping type reference storage by default
Local variables of value type (i.e. neither array, nor struct nor mapping) are stored in the stack

//什么时候需要这些声明
Most of the time you don't need to use these keywords because Solidity handles them by default but when dealing with complex data types like struts and arrays, 
you'll need to specify where you want to store them.



*/
