# @version 0.3.9

interface TargetContract:
    def num() -> uint256: view
    def set_num(_new_num: uint256) -> bool: nonpayable


target: public(address)


@external
def __init__(_target: address):
    self.target = _target


@view
@external
def get_num() -> uint256:
    return TargetContract(self.target).num()


@external
def call_target(_new_num: uint256):
    success: bool = TargetContract(self.target).set_num(_new_num)
    assert success, "call fail"