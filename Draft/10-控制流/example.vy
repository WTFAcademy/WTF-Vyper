# @version 0.3.9


NUMBER: constant(uint256) = 30


@view
@external
def is_active(_index: uint256) -> bool:
	"""
	@notice if-else 控制流语句
	"""
	if _index > 1:
		return True
	elif _index == 1:
		return False
	else:
		return False


@view
@external
def sum_numbers() -> uint256:
    total: uint256 = 0
    for i in range(0, 30):
        total += i
    return total


@view
@external
def sum_numbers1() -> uint256:
    total: uint256 = 0
    for i in range(0, NUMBER):
        total += i
    return total


# @view
# @external
# def sum_numbers_error(_number: uint256) -> uint256:
# 	"""
# 	@notice 错误写法
# 	"""
# 	total: uint256 = 0
# 	for i in range(0, _number):
# 		total += i
# 	return total


@view
@external
def get_max(_a: uint256, _b: uint256) -> uint256:
	"""
	@notice 三元运算
	"""
	return _a if _a > _b else _b