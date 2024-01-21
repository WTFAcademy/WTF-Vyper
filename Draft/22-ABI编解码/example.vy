# @version 0.3.9


@view
@external
def foo() -> Bytes[128]:
    x: uint256 = 1
    y: Bytes[32] = b"234"
    return _abi_encode(x, y)


@view
@external
def encode_abi() -> Bytes[132]:
    x: uint256 = 1
    y: Bytes[32] = b"234"
    return _abi_encode(x, y, method_id=method_id("foo()"))


# 使用 concat 拼接

@view
@external
def concat_abi() -> Bytes[132]:
    x: uint256 = 1
    y: Bytes[32] = b"234"
    return concat(
        method_id("foo()"),
        convert(x, bytes32),
        convert(y, bytes32)
    )


@view
@external
def decode_abi(_some_input: Bytes[128]) -> (uint256, Bytes[32]):
    x: uint256 = empty(uint256)
    y: Bytes[32] = empty(Bytes[32])
    x, y = _abi_decode(_some_input, (uint256, Bytes[32]))
    return x, y
