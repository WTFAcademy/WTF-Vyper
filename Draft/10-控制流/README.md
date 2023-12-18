# Vyper 入门： 10. 控制流

### 在 Vyper 中，控制流指导了程序如何根据不同的条件和循环进行操作。主要的控制流结构包括：

- `if-else` 语句：用于基于特定条件执行不同的代码块。
- `for` 循环：for 语句是一个控制流结构，用于迭代一个值
- `三元运算符`：提供一种简洁的方式来根据条件选择两个值中的一个。

### 与 solidity 不同的是，安全和可预测性的考虑，Vyper 中不存在 `while` 和 `do-while` 循环

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

## 2. for 循环

#### Vyper 中的 for 循环迭代值可以是静态数组、动态数组或从内置 range 函数生成，使用 `for i in range(START, STOP)` 循环时，`START` 和 `STOP` 的值必须是字面整数或者常量(constant)，无法使用参数或者内存变量

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
def sum_numbers1() -> uint256:
    total: uint256 = 0
    for i in range(0, NUMBER):
        total += i
    return total
```

#### 错误写法

```
@view
@external
def sum_numbers_error(_number: uint256) -> uint256:
    total: uint256 = 0
    for i in range(0, _number):
        total += i
    return total
```

## 3. 三元运算符

#### 与 Python 的三元运算符基本一致，唯一的区别在于 `Vyper` 不允许在 `if` 语句的条件内从非布尔类型进行隐式转换

#### 代码示例

#### 正确写法

```
@view
@external
def get_max(_a: uint256, _b: uint256) -> uint256:
	return _a if _a > _b else _b
```

#### 错误写法

```
@view
@external
def get_max(_a: uint256, _b: uint256) -> uint256:
	return _a if _a else _b
```

另外还有 continue（立即进入下一个循环）、break（跳出当前循环）和 pass (声明一个没有实现的函数)关键字可以使用，可以查看 [官方文档](https://docs.vyperlang.org/en/latest/statements.html#break) 。

## 总结

#### 本节中，我们介绍了 Vyper 中的控制流, 理解这些控制流机制对于编写有效且可靠的 Vyper 智能合约至关重要，它们使开发者能够根据不同的情况和数据来改变合约的行为。
