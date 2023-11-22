# Vyper 入门： 7. 映射类型
#### 在Vyper中，映射（Mapping）是一种将键映射到值的数据结构，用于存储键值对的集合，通过 `HashMap` 关键字定义

## 映射特点
- 键不会直接存储在映射中，而是通过其哈希值访问。
- 映射的值默认初始化为相应类型的默认值。
- 映射无法遍历，也没有提供长度属性。


## 映射声明
#### 映射声明需要指定键和值的类型，例如 `HashMap[_KeyType, _ValueType]`, 其中 `_KeyType` 可以是Vyper中的任何基本类型或字节类型，但是不支持映射、数组或结构作为键类型。`_ValueType` 则可以是任何类型，包括映射和结构。
#### 映射是状态变量，只在函数外部声明，无法在函数内部声明映射类型。

#### 示例代码
```
example_mapping: HashMap[uint256, uint256]

# 映射赋值
@external
def set_mapping():
	self.example_mapping[0] = 100

	# 无法在函数内部声明一个映射，这样会出错
	# example_mapping: HashMap[uint256, uint256]

```

### 映射使用
- 读取： 通过提供键来访问映射中的值
```
number: uint256 = self.example_mapping[0]
# number == 100
```

- 更新： 为给定的键分配新值
```
self.example_mapping[0] = 99
# number == 99
```

- 删除：将键的值重置为默认值
```
self.example_mapping[0] = empty(uint256)
# number == 0
```

## 总结
#### 映射在智能合约中非常有用，尤其是在需要有效地跟踪和更新状态的场景中。正确使用映射对于开发高效和安全的智能合约至关重要。比如存储资产所有权和代币余额，映射的作用往往比数组更加高效。