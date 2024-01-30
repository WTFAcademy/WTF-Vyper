# @version 0.3.9

# 常量
MAX_SUPPLY: constant(uint256) = 10000
NAME: constant(String[5]) = "Vyper"
PERMIT: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000000000000

OWNER: immutable(address)

@payable
@external
def __init__():
	OWNER = msg.sender


@view
@external
def get_max_supply() -> uint256:
	return MAX_SUPPLY


@view
@external
def get_name() -> String[5]:
	return NAME


@view
@external
def get_permit() -> bytes32:
	return PERMIT


@view
@external
def get_owner() -> address:
	return OWNER