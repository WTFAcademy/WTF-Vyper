# @version 0.3.9


event CreateNewContract:
    _new_contract: indexed(address)
    _salt: indexed(bytes32)


all_copied: public(HashMap[uint256, address])
all_copied_lenght: public(uint256)
target: public(address)


@external
def __init__(_target: address):
    self.target = _target


@external
def create_contract_copy(_salt: bytes32) -> address:
    new_contract: address = create_copy_of(self.target, salt=_salt)
    self.all_copied[self.all_copied_lenght] = new_contract
    self.all_copied_lenght += 1
    log CreateNewContract(new_contract, _salt)

    return new_contract