# @version 0.3.9

# 布尔值
is_bool: public(bool)

# 数值
int256_number: public(int256)
uint256_number: public(uint256)
decimal_number: public(decimal)

# 地址
owner: public(address)

# 字节
bytes32_hash: public(bytes32)
bytes_hash: public(Bytes[66])

# 字符串
string_name: public(String[5])


@payable
@external
def __init__():
	self.is_bool = True
	self.int256_number = -1
	self.uint256_number = 1
	self.decimal_number = 1.1
	self.owner = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
	self.bytes32_hash = 0x4f8b61438cf1d5e6f4f684d62bf496fc8975999b940392b49a2b70e209a69c12
	self.bytes_hash = b"0x4f8b61438cf1d5e6f4f684d62bf496fc8975999b940392b49a2b70e209a69c12"
	self.string_name = "Vyper"



@view
@external
def bool_operations() -> (bool, bool, bool):
	x: uint256 = 100
	y: uint256 = 200

	return x < y, x > y, x == y


@view
@external
def number_operations() -> (int256, uint256, decimal):
	x: int256 = -100
	y: int256 = 200

	x1: uint256 = 100
	y1: uint256 = 200

	x2: decimal = 100.0
	y2: decimal = 200.0
	
	return x - y, x1 + y1, x2 * y2


