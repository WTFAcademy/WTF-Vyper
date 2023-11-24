# Vyper 入门： 13. 接口
### 在Vyper中，接口（Interface）是定义外部合约调用的一种方式，允许你的合约与其他合约进行交互。

## 接口
### 定义
- 接口是一组函数定义，用于在智能合约之间启用通信​
- 通过定义外部合约的公开函数，接口使合约知道如何调用其他合约中的这些函数
- 接口可以通过内联定义或从单独的文件导入来添加到合约中

### 声明
#### Vyper中使用 `interface` 关键字定义内联外部接口
#### 示例代码
```
# 接口构造
interface [<接口名称>]:
	def [<接口函数>] -> [<接口返回的值类型>]: [<函数注解>]

interface FooBar:
    def calculate() -> uint256: view
    def test1(): nonpayable
```

### 使用
#### 接口的使用有两种方式，直接调用和声明为存储变量后调用
1. 直接调用是最简单，也是最常用的一种调用方式，示例代码：
```
@view
@external
def get_calculate() -> uint256:
	return Foobar(contract).calculate()
```
#### 代码中的 `contract` 是你想要调用的合约地址

2. 将接口声明为存储变量是特定的使用场景中使用的一种调用方式，你可以为变量分配一个地址值以访问该接口，示例代码：

```
foobar_contract: FooBar

@external
def __init__(foobar_address: address):
    self.foobar_contract = FooBar(foobar_address)

@external
def test():
    self.foobar_contract.calculate()
```

#### 注意，为接口分配地址时，你需要先将地址转换成接口类型，例如 `FooBar(foobar_address)`，转换后才可以赋值给状态变量。你也可以使用以下方式来转换地址类型：

```
foobar_contract: FooBar

@external
def __init__(foobar_address: FooBar):
    self.foobar_contract = foobar_address
```

### 函数注解
#### 在Vyper的接口定义中，每一个接口函数都必须要有函数注解，标明函数注解才能够知道函数的类型，函数注解有以下几种：
- `payable`: 需要发送ETH的函数，并且执行期间会更改调用合约的存储
- `nonpayable`: 不需要发送ETH的函数，执行期间只更改调用合约的存储
- `view` 和 `pure`: 视图函数，执行期间不会更改调用合约的存储

#### 示例代码
```
interface FooBar:
    def calculate() -> uint256: pure
    def query() -> uint256: view
    def update(): nonpayable
    def pay(): payable

@external
def test(foobar: FooBar):
    foobar.calculate()  # 不会更改储存
    foobar.query()  # 不会更改储存
    foobar.update()  # 会更改存储
    foobar.pay(value=1)  # 会更改存储，并且可以发送ETH
```

#### Vyper还可以在调用时添加关键字参数，有以下几种：
- `gas`: 指定调用的gas值
- `value`: 指定随调用发送的ETH值
- `skip_contract_check`: 不常用，删除 `EXTCODESIZE` 和 `RETURNDATASIZE` 检查
- `default_return_value`: 如果没有返回值，指定默认返回值。`default_return_value` 参数可用于处理受缺少返回值错误影响的 `ERC20` 代币。使用方式 `default_return_value=True`

## 导入接口
#### Vyper还支持从外部接口文件中导入接口，并且提供了 `ERC20` 和 `ERC721` 两种内置接口，下面我们通过内置接口来介绍如何导入接口。
#### 导入外部文件接口通过两种方式导入：`from ... import ...` 和 `import ...`，使用方式和Python类似

#### 示例代码
```
# 使用内置接口
from vyper.interfaces import ERC20
implements: ERC20

from vyper.interfaces import ERC721
implements: ERC721

@view
@external
def get_name(_token: address) -> String[50]:
	return ERC20(_token).name()

@view
@external
def get_name(_token: address) -> String[50]:
	return ERC721(_token).name()

```
#### 你可以在 [Vyper Github](https://github.com/vyperlang/vyper/tree/master/vyper/builtins/interfaces) 上查看所有的内置接口

## 总结
#### 在本节中，我们介绍了接口的定义和使用。在合约编写过程，声明接口和内置接口是最常用的两种接口使用方式，通过外部文件的方式导入合约并不常用，如果想了解更多关于接口的资料，可以查看 [官方文档](https://docs.vyperlang.org/en/latest/interfaces.html)