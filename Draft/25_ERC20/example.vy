# pragma version 0.3.10

from vyper.interfaces import ERC20
from vyper.interfaces import ERC20Detailed

implements: ERC20
implements: ERC20Detailed


event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256


event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

totalSupply: public(uint256)
balanceOf: public(HashMap[address, uint256])
allowance: public(HashMap[address, HashMap[address, uint256]])

name: public(immutable(String[32]))
symbol: public(immutable(String[32]))
decimals: public(immutable(uint8))


@payable
@external
def __init__(_name: String[32], _symbol: String[32], _decimals: uint8, _total_supply: uint256):
    name = _name
    symbol = _symbol
    decimals = _decimals
    self.totalSupply = _total_supply


@external
def transfer(_to: address, _value: uint256) -> bool:
    self.balanceOf[msg.sender] -= _value
    self.balanceOf[_to] += _value
    log Transfer(msg.sender, _to, _value)
    return True


@external
def transferFrom(_from: address, _to: address, _value: uint256) -> bool:
    self.balanceOf[_from] -= _value
    self.balanceOf[_to] += _value
    self.allowance[_from][msg.sender] -= _value
    log Transfer(_from, _to, _value)
    return True


@external
def approve(_spender: address, _value: uint256) -> bool:
    self.allowance[msg.sender][_spender] = _value
    log Approval(msg.sender, _spender, _value)
    return True


@external
def mint(_value: uint256) -> bool:
    self.balanceOf[msg.sender] += _value
    self.totalSupply += _value
    log Transfer(empty(address), msg.sender, _value)
    return True


@external
def burn(_value: uint256) -> bool:
    self.balanceOf[msg.sender] -= _value
    self.totalSupply -= _value
    log Transfer(msg.sender, empty(address), _value)
    return True