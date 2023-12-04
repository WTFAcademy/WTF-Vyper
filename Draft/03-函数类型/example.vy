# @version 0.3.9

num1: public(uint256)
num2: public(uint256)

@payable
@external
def __init__():
	pass

@view
@internal
def _internal_view_function() -> uint256:
	return 99

@view
@external
def external_view_function() -> uint256:
	return self.num1

@view
@external
def view_internal_function() -> uint256:
	return self._internal_view_function()

@pure
@external
def external_pure_function() -> uint256:
	return 100

@internal
def _internal_function(_new_num: uint256):
	self.num2 = _new_num

@external
def call_internal_function(_new_num: uint256):
	self._internal_function(_new_num)


@external
def call_internal_view_function():
	self.num2 = self._internal_view_function()


# payable 类型
@payable
@external
def receipt_eth():
	pass

@payable
@external
def __default__():
	pass


# 防重入
@nonreentrant("lock")
@external
def sensitive_function():
    pass