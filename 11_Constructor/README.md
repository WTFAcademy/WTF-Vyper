# Vyper 入门： 11. 构造函数和回调函数

### 在 Vyper 中，构造函数是一种特殊的函数，在合约部署时自动执行一次，用于设置初始状态和变量。构造函数使用特殊的名字 `__init__`。

## 构造函数

### 1. 定义构造函数

- 使用 `@external` 修饰符和 `def __init__` 来定义，注意 `init` 前后分别是 2 条下划线
- 修饰符 `@payable` 可选，只要作用用于部署时接收 ETH 和节省 gas
- 可以接受参数，用于设置合约的初始状态。

#### 示例代码

```
owner: public(address)

@payable
@external
def __init__(_owner: address):
	self.owner = _owner
```

### 2. 构造函数中的操作

- 常用于设置合约拥有者、初始化状态变量等。
- 可以包含任何逻辑，但需确保操作安全，因为它在合约生命周期中仅执行一次。

### 3. 注意事项

- 不要在构造函数中进行复杂的计算或可能失败的操作，以避免部署失败。
- 确保所有重要的初始状态都在构造函数中正确设置。

## 回调函数

#### 在 Vyper 中，`__default__` 函数是一种特殊的函数，如果没有其他函数与给定的函数标识符匹配（或者根本没有提供任何函数，例如通过某人发送 ETH），则在调用合约时执行该默认函数。它与 `Solidity` 中的 `fallback` 函数具有相同的构造。

#### 该函数始终命名为 `__default__` 。必须使用装饰器 `@external`。它不能有任何输入参数。如果该函数存在装饰器 `@payable`，则每当合约发送以太币（无数据）时，该函数就会执行。这就是为什么默认函数不能接受参数——以太坊不区分将以太发送到合约或用户地址。

#### 通过 `__default__` 函数我们可以通 `solidity` 的 `fallback` 功能一样实现代理合约，以下示例代码实现了 ETH 接收和代理合约，具体代理合约实现我们将在之后的教程中详细介绍

#### 示例代码

```
# @version 0.3.9
"""
@title Simple Proxy
@author 0x77
"""

event Received:
	_sender: indexed(address)
	_amount: indexed(uint256)
	_data: Bytes[1024]

implementation: public(address)


@payable
@external
def __init__(_implementation: address):
	self.implementation = _implementation


@payable
@external
def __default__() -> Bytes[255]:

	if len(msg.data) == 0:
		log Received(msg.sender, msg.value, b"")
		return b""

	response: Bytes[255] = raw_call(
		self.implementation,
		msg.data,
		max_outsize=255,
		value=msg.value,
		is_delegate_call=True
	)

	assert len(response) != 0, "CALL FAIL"
	return response

```

## 总结

#### 本节中，我们介绍了构造函数 `__init__` 和回调函数 `__default__` 的使用，并且简单的编写了一个代理合约，关于代理合约我们将在之后的教程中详细介绍。
