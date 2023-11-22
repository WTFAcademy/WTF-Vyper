# Vyper 入门： 9. 常数
### 在Vyper中，`constant` 和 `immutable` 是两种特殊的变量类型，它们用于定义不变的值，还可以节省gas。与solidity不同的是，`constant` 和 `immutable`可以声明所有的变量类型

## 1. Constant 变量
#### `constant` 变量是在编译时就确定的常量。它们不占用区块链存储空间。通常用于定义那些在合约代码中不会改变的值，如最大供应量、地址等

#### 代码示例
```
MAX_SUPPLY: constant(uint256) = 10000
NAME: constant(String[5]) = "Vyper"
PERMIT: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000000000000
```

## 2. Immutable 变量
#### `immutable` 变量是在合约部署时在构造函数中设定一次，之后不能更改的变量，通常适用于那些需要在部署时设置，但之后不会改变的值，如合约创建者地址
#### 代码示例
```
OWNER: immutable(address)

@payable
@external
def __init__():
	OWNER = msg.sender

```

#### 常量无法被外部直接访问，通常需要编写指定的视图函数进行访问
#### 代码示例
```
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
```

![常量](./constant.png)

## 总结
#### 在本节中，我们介绍了 `constant` 和 `immutable`。如何正确选择需要根据需求来使用，`constant` 对于编译时已知且永远不会改变的值。`immutable` 对于需要在部署时确定，但后续不变的值。