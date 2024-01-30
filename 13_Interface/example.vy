# @version 0.3.9

# from vyper.interfaces import ERC20
# implements: ERC20

# from vyper.interfaces import ERC721
# implements: ERC721

interface FooBar:
    def calculate() -> uint256: pure
    def query() -> uint256: view
    def update(): nonpayable
    def pay(): payable


@view
@external
def get_calculate(_contract: address) -> uint256:
	return FooBar(_contract).calculate()

# @view
# @external
# def get_name(_token: address) -> String[50]:
# 	return ERC20(_token).name()

# @view
# @external
# def get_erc721_name(_token: address) -> String[50]:
# 	return ERC721(_token).name()


@external
def test(foobar: FooBar):
    foobar.calculate()  # 不会更改储存
    foobar.query()  # 不会更改储存
    foobar.update()  # 会更改存储
    foobar.pay(value=1)  # 会更改存储，并且可以发送ETH