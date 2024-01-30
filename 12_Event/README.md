# Vyper 入门： 12. 事件
### Vyper的事件日志功能允许智能合约与外部界面和监听者进行通信。事件的作用是记录事件，供用户界面捕获和显示

## 声明事件
#### 事件声明看起来与结构声明类似，包含一个或多个传递给事件的参数。典型的事件将包含两种参数：
- `索引参数`: 通过 `indexed` 关键字标识，可以被监听者搜索，但不直接传递给监听者。
- `值参数`: 直接传递给监听者，每个参数大小限制为32字节以内。
- 也可以创建不带参数的事件。在这种情况下使用 `pass` 语句：`event Foo: pass`


#### 代码示例
```
event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256
```

## 记录事件
#### 声明事件后，你可以记录发送的事件。还可以根据需求多次发送事件
- 使用 `log` 语句发送事件
- 发送的事件不占用状态存储，因此不消耗Gas，这使得事件成为保存某些信息的好方法
- 注意：事件对合约自身不可用，只对客户端可用​。给定参数的顺序和类型必须与声明事件时使用的参数顺序相匹配。

#### 示例代码
```
log Transfer(msg.sender, _to, _amount)
```

## 监听事件
#### 事件发出后，我们可以编写代码监听事件，也可以直接从区块浏览器中查看，本节中我们介绍如何使用 `web3py` 编写代码监听事件。
#### 以ERC20代币中的 `Transfer` 事件为例，当合约发送这个日志事件时，回调函数将被调用，监听的客户端就可以监听到这个事件
#### 示例代码
```
abi = # 编译器生成的abi
address = # 需要监听的合约地址
my_contract = web3.eth.contract(address=address, abi=abi)

event_filter = my_contract.events.Transfer.createFilter(fromBlock='latest')
event = event_filter.get_new_entries():

# 获取到的事件输出类似这样
[
	AttributeDict(
		{'args': AttributeDict(
			{
				'from': '0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf',
				'to': '0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf',
				'value': 10}),
				'event': 'Transfer',
				'logIndex': 0,
				'transactionIndex': 0,
				'transactionHash': HexBytes('...'),
				'address': '0xF2E246BB76DF876Cef8b38ae84130F4F55De395b',
				'blockHash': HexBytes('...'),
				'blockNumber': 3
			}
 	)
 ]

```
#### 如果对监听事件感兴趣，可以查看 [web3py](https://web3py.readthedocs.io/en/stable/web3.contract.html#web3.contract.ContractEvents) 的官方文档


## 总结
#### 本节中，我们介绍了事件和如何监听事件。如果需要从事区块链数据分析工作，那么需要熟悉掌握如何从链上获取数据并分析