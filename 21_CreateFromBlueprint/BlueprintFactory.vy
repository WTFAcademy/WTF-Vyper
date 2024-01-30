from vyper.interfaces import ERC20


event BlueprintCreated:
    blueprint: address


EIP5202_CODE_OFFSET: constant(uint256) = 3
BLUEPRINT: immutable(address)


@external
def __init__(_blueprint_address: address):
    BLUEPRINT = _blueprint_address


@external
def create_new_erc20(_name: String[32], _symbol: String[32], _decimals: uint8, _supply: uint256) -> ERC20:
    new_erc20: address = create_from_blueprint(
        BLUEPRINT,
        _name,
        _symbol,
        _decimals,
        _supply,
        code_offset=EIP5202_CODE_OFFSET
    )
    
    log BlueprintCreated(new_erc20)
    return ERC20(new_erc20)