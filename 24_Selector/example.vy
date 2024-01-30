# @version 0.3.9


@view
@external
def foo() -> Bytes[4]:
    return method_id('transfer(address,uint256)', output_type=Bytes[4])

@view
@external
def bar() -> bytes4:
    return method_id('transfer(address,uint256)', output_type=bytes4)