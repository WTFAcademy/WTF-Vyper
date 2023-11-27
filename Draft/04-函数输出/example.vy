# @version 0.3.9

balances: uint256
num: uint256
num1: public(uint256)
num2: public(uint256)
num3: public(uint256)


@view
@external
def get_balance() -> uint256:
	"""
	@notice 返回单值
	"""
	return self.balances


@view
@external
def multi_return() -> (uint256, uint256, uint256):
	"""
	@notice 返回多值
	"""
	return self.num1, self.num2, self.num3


@view
@internal
def _get_balance() -> uint256:
	return self.balances


@external
def update_balance():
	"""
	@notice 存储返回值
	"""
	self.num = self._get_balance()