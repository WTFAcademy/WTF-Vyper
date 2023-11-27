# @version 0.3.9

struct MyStruct:
    value1: uint256
    value2: decimal

# 初始化一个结构体
example_struct: public(MyStruct)

# 固定数组
owners: address[3]
numbers: uint256[3]
bytess: bytes32[3]

# 声明一个整数数组
example_list: DynArray[uint256, 3]

@external
def setting():
	# 添加整数
	self.example_list.append(100)
	self.example_list.append(200)
	self.example_list.append(300)
	
	# 移除整数
	self.example_list.pop()


# 给结构体赋值
# 方式1: 声明一个结构体赋值
@external
def set_struct():
	self.example_struct = MyStruct({value1: 100, value2: 99.0})


# 方式2: 直接对结构体赋值
@external
def set_struct1():
	self.example_struct.value1 = 1
	self.example_struct.value2 = 2.0
