interface ReceiverInterface:
    def receive_eth(): payable


@external
def send_eth(_receiver: address, _amount: uint256):
    send(_receiver, _amount)


@external
def raw_call_eth(_receiver: address, _amount: uint256):
    response: Bytes[32] = raw_call(
        _receiver, 
        b"", 
        value=_amount, 
        max_outsize=32
    )

    if len(response) != 0:
        assert convert(response, bool)


@external
def interface_send_eth(_receiver_addr: ReceiverInterface, _amount: uint256):
    _receiver_addr.receive_eth(value=_amount)
