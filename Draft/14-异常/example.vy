# @version 0.3.9


@external
def get_revert(_number: uint256):
	if _number == 0:
		raise "wrong number"


@external
def check_assert(_number: uint256):
	assert _number != 0, "wrong number"


# 等同于
@external
def check_assert2(_number: uint256):
	if _number == 0:
		raise "wrong number"


@external
def get_invalid(_number: uint256):
	if _number == 0:
		raise "UNREACHABLE"