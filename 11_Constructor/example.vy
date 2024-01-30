# @version 0.3.9
"""
@title Simple Proxy
@author 0x77
"""

event Received:
	_sender: indexed(address)
	_amount: indexed(uint256)
	_data: Bytes[1024]

implementation: public(address)


@payable
@external
def __init__(_implementation: address):
	self.implementation = _implementation


@payable
@external
def __default__() -> Bytes[255]:

	if len(msg.data) == 0:
		log Received(msg.sender, msg.value, b"")
		return b""

	response: Bytes[255] = raw_call(
		self.implementation,
		msg.data,
		max_outsize=255,
		value=msg.value,
		is_delegate_call=True
	)

	assert len(response) != 0, "CALL FAIL"
	return response
