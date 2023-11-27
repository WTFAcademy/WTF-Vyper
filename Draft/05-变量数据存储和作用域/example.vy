# @version 0.3.9


# 不可变量, 不需要在构造函数中赋值
NUMBER: immutable(uint256)

# 常量, 必须先赋值
OWNER: constant(address) = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE

# 访问合约的状态变量
state_var: uint256
balances: public(uint256)


@payable
@external
def __init__():
	NUMBER = 100


@view
@external
def env_variable() -> (address, uint256, Bytes[255]):
	"""
	@notice 环境变量
	"""
	caller: address = msg.sender
	block_number: uint256 = block.number
	call_data: Bytes[255] = slice(msg.data, 0, 4)

	return caller, block_number, call_data


@view
@external
def get_var() -> uint256:
    return self.state_var


# 调用内部函数
@internal
def _times_two(_amount: uint256) -> uint256:
    return _amount * 2


@external
def update_balance(_new_balance: uint256):
	"""
	@notice 存储变量
	"""
	self.balances = _new_balance


@external
def update_balance2():
	# 内存变量
	memory_balance: uint256 = self.balance
	memory_balance += 1


@external
def set_var(_value: uint256) -> bool:
    self.state_var = _value
    return True


@external
def calculate(_amount: uint256) -> uint256:
    return self._times_two(_amount)