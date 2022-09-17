

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

function store2() public {
        uint256 storage number2 = 123;
    }

TypeError: Data location can only be specified for array, struct or mapping types, but "storage" was given.

# 这个value仅仅有指针的意义？对value的任何操作都会反映到someData上
contract StoragePointer {
    uint256[] public someData;
    
    function pushToArrayViaPointer() public {
       
        uint256[] storage value = someData;
        value.push(12);
    }
}

# 以下例子说明，storage声明的local variable只能做为state variable的指针存在
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
