# @version 0.3.9


x: public(uint256)
y: public(uint256)

target: public(address)
add_num: public(uint256)
sub_num: public(uint256)


@external
def __init__(_target: address):
    self.target = _target


@view
@external
def get_sender() -> address:
    response: Bytes[32] = raw_call(
        self.target,
        method_id("sender()"),
        max_outsize=32,
        is_static_call=True
    )

    return extract32(response, 0, output_type=address)


@external
def raw_call_test_add(_x: uint256, _y: uint256):
    response: Bytes[32] = raw_call(
        self.target,
        _abi_encode(
            _x, # 第一个参数
            _y, # 第二个参数
            method_id=method_id("test_add(uint256,uint256)") # 调用的函数签名
        ),
        max_outsize=32
    )

    # 将返回的字节数组转化成整型
    self.add_num = convert(response, uint256)


@external
def raw_call_test_sub(_x: uint256, _y: uint256):
    success: bool = False
    response: Bytes[32] = b""
    success, response = raw_call(
        self.target,
        concat(
            method_id("test_sub(uint256,uint256)"), # 函数签名
            convert(_x, bytes32), # 第一个参数
            convert(_y, bytes32) # 第二个参数
        ),
        max_outsize=32,
        gas=100000,
        value=0,
        revert_on_failure=False
    )

    assert success
    self.sub_num = convert(response, uint256)


@external
def delegate_call_x(_x: uint256):
    raw_call(
        self.target,
        _abi_encode(
            _x,
            method_id=method_id("update_x(uint256)")
        ),
        is_delegate_call=True
    )


@external
def delegate_call_y(_y: uint256):
    raw_call(
        self.target,
        _abi_encode(
            _y,
            method_id=method_id("update_y(uint256)")
        ),
        is_delegate_call=True
    )