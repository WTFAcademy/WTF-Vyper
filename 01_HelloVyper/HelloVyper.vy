# pragma version 0.4.3

greet: public(String[12])

@payable
@deploy
def __init__():
	self.greet = "Hello Vyper!"
