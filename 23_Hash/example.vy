# @version 0.3.9


@view
@external
def keccak(_value: Bytes[100]) -> bytes32:
    return keccak256(_value)


@view
@external
def sha(_value: Bytes[100]) -> bytes32:
    return sha256(_value)


