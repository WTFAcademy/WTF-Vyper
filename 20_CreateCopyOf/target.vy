# pragma version 0.4.3

event UpdateNum:
    _old_num: indexed(uint256)
    _new_num: indexed(uint256)


num: public(uint256)


@deploy
def __init__():
    pass


@external
def update_num(_new_num: uint256) -> bool:
    old_num: uint256 = self.num
    self.num = _new_num
    log UpdateNum(old_num, _new_num)

    return True