# @version 0.3.9


interface ProxyWallet:
    def initialization(_implementation: address) -> bool: nonpayable


event WalletCreate:
    _wallet: indexed(address)
    _value: indexed(uint256)
    _salt: indexed(bytes32)


COLLISION_OFFSET: constant(bytes1) = 0xFF

implementation: public(address)
wallet: public(address)
all_wallet_length: public(uint256)
all_wallets: public(HashMap[uint256, address])
is_wallet: public(HashMap[address, bool])


@external
def __init__(_wallet: address, _implementation: address):
    self.wallet = _wallet
    self.implementation = _implementation


@pure
@internal
def _compute_address(_salt: bytes32, _bytecode_hash: bytes32, _deployer: address) -> address:
    data: bytes32 = keccak256(concat(COLLISION_OFFSET, convert(_deployer, bytes20), _salt, _bytecode_hash))
    return self._convert_keccak256_2_address(data)


@pure
@internal
def _convert_keccak256_2_address(_digest: bytes32) -> address:
    return convert(convert(_digest, uint256) & convert(max_value(uint160), uint256), address)


@view
@external
def compute_address_self(_salt: bytes32, _bytecode_hash: bytes32) -> address:
    return self._compute_address(_salt, _bytecode_hash, self)


@pure
@external
def compute_address(_salt: bytes32, _bytecode_hash: bytes32, _deployer: address) -> address:
    return self._compute_address(_salt, _bytecode_hash, _deployer)


@external
def create_wallet(_salt: bytes32) -> address:
    new_wallet: address = create_minimal_proxy_to(self.wallet, salt=_salt)
    assert ProxyWallet(new_wallet).initialization(self.implementation)

    self.all_wallets[self.all_wallet_length] = new_wallet
    self.is_wallet[new_wallet] = True
    self.all_wallet_length += 1
    
    log WalletCreate(new_wallet, 0, _salt)

    return new_wallet