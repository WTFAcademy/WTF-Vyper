# @version 0.3.9


# 默认值
example_address: public(address)
example_bool: public(bool)
example_bytes32: public(bytes32)
example_bytes: public(Bytes[255])
example_string: public(String[255])
example_uint256: public(uint256)
example_decimal: public(decimal)

example_mapping: public(HashMap[uint256, uint256])

struct ExampleStruct:
	id: uint256
	name: address

example_array: public(uint256[3])
example_dynarray: public(DynArray[uint256, 3])