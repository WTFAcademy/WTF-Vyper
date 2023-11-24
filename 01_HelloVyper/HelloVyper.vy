# @version 0.3.9

greet: public(String[12])

@payable
@external
def __init__():
	self.greet = "Hello Vyper!"
