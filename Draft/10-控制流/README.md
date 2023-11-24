# Vyper 入门： 10. 控制流
### 在Vyper中，控制流指导了程序如何根据不同的条件和循环进行操作。主要的控制流结构包括：
- `if-else` 语句：用于基于特定条件执行不同的代码块。
- `for` 循环：for语句是一个控制流结构，用于迭代一个值
- `三元运算符`：提供一种简洁的方式来根据条件选择两个值中的一个。

### 与solidity不同的是，安全和可预测性的考虑，Vyper中不存在 `while` 和 `do-while` 循环

## 1. if-else
#### 请注意，与 Python 不同，Vyper 不允许在 `if` 语句的条件内从非布尔类型进行隐式转换。 比如`if 1: pass` 将因类型不匹配而无法编译。
#### 代码示例
```
@view
@external
def is_active(_index: uint256) -> bool:
	if _index > 1:
		return True
	elif _index == 1:
		return False
	else:
		return False
``` 

## 2. for循环
#### Vyper中的for循环迭代值可以是静态数组、动态数组或从内置range函数生成，使用 `for i in range(START, STOP)` 循环时，`START` 和 `STOP` 的值必须是字面整数或者常量(constant)，无法使用参数或者内存变量
#### 代码示例
#### 正确写法
```
NUMBER: constant(uint256) = 30

@view
@external
def sum_numbers() -> uint256:
    total: uint256 = 0
    for i in range(0, 30):
        total += i
    return total

@view
@external
def sum_numbers() -> uint256:
    total: uint256 = 0
    for i in range(0, NUMBER):
        total += i
    return total
```

#### 错误写法
```
@view
@external
def sum_numbers(_number: uint256) -> uint256:
    total: uint256 = 0
    for i in range(0, _number):
        total += i
    return total
```

## 3. 三元运算符
#### 与Python的三元运算符基本一致，唯一的区别在于 `Vyper` 不允许在 `if` 语句的条件内从非布尔类型进行隐式转换

#### 代码示例
#### 错误写法
```
@view
@external
def get_max(_a: uint256, _b: uint256) -> uint256:
	return _a if _a else _b
```

#### 正确写法
```
@view
@external
def get_max(_a: uint256, _b: uint256) -> uint256:
	return _a if _a > _b else _b
```

## 总结
#### 本节中，我们介绍了Vyper中的控制流, 理解这些控制流机制对于编写有效且可靠的Vyper智能合约至关重要，它们使开发者能够根据不同的情况和数据来改变合约的行为。
