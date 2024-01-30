# @version 0.3.9

interface CreateAddress:
    def compute_address(_salt: bytes32, _bytecode_hash: bytes32, _deployer: address, _input: Bytes[4096]) -> address: pure


CREATE2_PREFIX: constant(bytes32) = 0x2020dba91b30cc0006188af794c2fb30dd8520db7e2c088b7fc7c103c00ca494


@pure
@external
def compute_address(_salt: bytes32, _bytecode_hash: bytes32, _deployer: address, _input: Bytes[4_096]=b"") -> address:

    constructor_input_hash: bytes32 = keccak256(_input)
    data: bytes32 = keccak256(concat(CREATE2_PREFIX, empty(bytes12), convert(_deployer, bytes20), _salt, _bytecode_hash, constructor_input_hash))

    return convert(convert(data, uint256) & convert(max_value(uint160), uint256), address)


@view
@external
def compute_address_self(_salt: bytes32, _bytecode_hash: bytes32, _deployer: address, _input: Bytes[4096]) -> address:
    return CreateAddress(self).compute_address(_salt, _bytecode_hash, _deployer, _input)


