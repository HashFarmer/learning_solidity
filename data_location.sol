

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




*/
