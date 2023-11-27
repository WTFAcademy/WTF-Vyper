# @version 0.3.9

event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256


@external
def transfer(_to: address, _amount: uint256):
	log Transfer(msg.sender, _to, _amount)
