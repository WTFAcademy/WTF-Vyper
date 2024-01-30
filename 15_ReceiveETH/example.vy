# @version 0.3.9

event Received:
    _sender: indexed(address)
    _amount: indexed(uint256)
    _data: Bytes[1024]


@payable
@external
def receive_eth():
    log Received(msg.sender, msg.value, b"")


@payable
@external
def __default__():
    log Received(msg.sender, msg.value, b"")
