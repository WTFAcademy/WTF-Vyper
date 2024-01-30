# @version 0.3.9
"""
@title Vyper Proxy
@author 0x77
"""


event Received:
    _sender: indexed(address)
    _amount: uint256
    _data: Bytes[1024]

event ChangeAdmin:
    _old_admin: indexed(address)
    _new_admin: indexed(address)

event Execute:
    _to: indexed(address)
    _value: indexed(uint256)
    _data: indexed(Bytes[max_value(uint16)])


admin: public(address)


@payable
@external
def __init__():
    self.admin = msg.sender


@view
@internal
def _check_module(_module: address) -> bool:
    """
    检查调用代理合约的地址是否为授权的地址
    """
    return True


@pure
@internal
def _enabled_method(_method: bytes4) -> address:
    """
    这个函数的设计旨在支持特定的函数签名调用。通常情况下，在代理合约中，并不是所有函数都应被允许调用。
    相反，应该精心控制允许调用的函数列表，以避免由于滥用调用而产生的安全隐患。   
    """
    return empty(address)


@external
def set_admin(_new_admin: address):
    assert msg.sender == self.admin, "Only admin"

    old_admin: address = self.admin
    self.admin = _new_admin
    log ChangeAdmin(old_admin, _new_admin)


@external
def execute(_target: address, _amount: uint256, _data: Bytes[4096]) -> bool:
    assert self._check_module(msg.sender)

    success: bool = False
    response: Bytes[32] = b""

    success, response = raw_call(_target, _data, max_outsize=32, value=_amount, revert_on_failure=False)

    if len(response) != 0:
        assert convert(response, bool)

    assert success

    log Execute(_target, _amount, _data)
    return True


@payable
@external
def __default__() -> Bytes[32]:
    method: bytes4 = convert(slice(msg.data, 0, 4), bytes4)
    module: address = self._enabled_method(method)

    if module == empty(address):
        log Received(msg.sender, msg.value, b"")
        return b""

    assert self._check_module(module)

    response: Bytes[32] = raw_call(
        module,
        msg.data,
        max_outsize=32,
        is_static_call=True
    )

    if len(response) != 0:
        assert convert(response, bool), "APE003"
    else:
        raise "non-response"

    return response

