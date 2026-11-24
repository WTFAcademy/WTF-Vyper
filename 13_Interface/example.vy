# pragma version 0.4.3

# from ethereum.ercs import IERC20 as ERC20
# implements: ERC20

# from ethereum.ercs import IERC721 as ERC721
# implements: ERC721

interface FooBar:
    def calculate() -> uint256: pure
    def query() -> uint256: view
    def update(): nonpayable
    def pay(): payable


@view
@external
def get_calculate(_contract: address) -> uint256:
	return staticcall FooBar(_contract).calculate()

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
    _calculate: uint256 = staticcall foobar.calculate()  # 不会更改储存
    _query: uint256 = staticcall foobar.query()  # 不会更改储存
    extcall foobar.update()  # 会更改存储
    extcall foobar.pay(value=1)  # 会更改存储，并且可以发送ETH