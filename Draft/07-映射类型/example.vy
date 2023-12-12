# @version 0.3.9

example_mapping: public(HashMap[uint256, uint256])

# 映射赋值
@external
def set_mapping():
	self.example_mapping[0] = 100

	# 无法在函数内部声明一个映射，这样会出错
	# example_mapping: HashMap[uint256, uint256]


@view
@external
def view_mapping() -> uint256:
	return self.example_mapping[0]


@external
def update_mapping():
	self.example_mapping[0] = 99
	self.example_mapping[0] = empty(uint256)
