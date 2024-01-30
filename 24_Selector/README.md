# Vyper 入门: 24. 选择器

函数选择器(Selector) 是智能合约中一个特定函数的唯一标识符。在以太坊的智能合约中，每个函数都有一个与之对应的选择器

在以太坊中，我们实际是向合约发送一段 `calldata` 与之交互，其中选择器就是这段 `calldata` 数据前4个字节

`0xa9059cbb000000000000000000000000920c582818275f09dbf7feb479c01206ad0dd631000000000000000000000000000000000000000000000000000000000ee6b280`

其中 `0xa9059cbb` 就是选择器


## method_id

Vyper 中提供 `method_id` 函数，用于生成给定函数的选择器，同时构造低级别的合约调用，或在合约中动态引用其他合约的函数

语法:

```
method_id(method, output_type: type = Bytes[4]) -> Union[Bytes[4], bytes4]
```

- `method`: 字符串形式的方法声明
- `output_type`: 输出类型, Bytes[4] 或 bytes4，默认输出 Bytes[4]

返回值根据 `output_type` 指定的类型


代码示例:

```
@view
@external
def foo() -> Bytes[4]:
    return method_id('transfer(address,uint256)', output_type=Bytes[4])

@view
@external
def bar() -> bytes4:
    return method_id('transfer(address,uint256)', output_type=bytes4)
```

![method](./image/method.png)


由于函数选择器只有4字节，非常短，很容易被碰撞出来：即我们很容易找到两个不同的函数，但是他们有着相同的函数选择器。比如 `transferFrom(address,address,uint256)` 和 `gasprice_bit_ether(int128)` 有着相同的选择器：`0x23b872dd`

在这种情况下可能会出现选择器碰撞攻击，详情可以查看 [选择器攻击示例](https://www.wtf.academy/solidity-104/SelectorClash/)


## 总结
本节中，我们介绍了如何使用 `method_id` 生成函数选择器，需要注意函数签名必须精确匹配，包括函数名和参数类型，任何偏差都会导致错误的选择器