# pragma version ^0.3.10

from vyper.interfaces import ERC165
implements: ERC165


interface IERC1155Receiver:
    def onERC1155Received(
       operator: address,
       sender: address,
       id: uint256,
       amount: uint256,
       data: Bytes[_CALLBACK_NUMBYTES],
   ) -> bytes4: payable
    def onERC1155BatchReceived(
        operator: address,
        sender: address,
        ids: DynArray[uint256, _BATCH_SIZE],
        amounts: DynArray[uint256, _BATCH_SIZE],
        data: Bytes[_CALLBACK_NUMBYTES],
    ) -> bytes4: payable

interface IERC1155MetadataURI:
    def uri(id: uint256) -> String[512]: view

event TransferSingle:
    operator: indexed(address)
    owner: indexed(address)
    to: indexed(address)
    id: uint256
    amount: uint256

event TransferBatch:
    operator: indexed(address)
    owner: indexed(address)
    to: indexed(address)
    ids: DynArray[uint256, _BATCH_SIZE]
    amounts: DynArray[uint256, _BATCH_SIZE]

event ApprovalForAll:
    owner: indexed(address)
    operator: indexed(address)
    approved: bool

event URI:
    value: String[512]
    id: indexed(uint256)


_SUPPORTED_INTERFACES: constant(bytes4[3]) = [
    0x01FFC9A7, 
    0xD9B67A26, 
    0x0E89341C
]


_BATCH_SIZE: constant(uint16) = 255
_BASE_URI: immutable(String[80])
_CALLBACK_NUMBYTES: constant(uint256) = 4096

name: public(String[25])
symbol: public(String[25])
isApprovedForAll: public(HashMap[address, HashMap[address, bool]])
total_supply: public(HashMap[uint256, uint256])
is_minter: public(HashMap[address, bool])
owner: public(address)
_balances: HashMap[uint256, HashMap[address, uint256]]
_token_uris: HashMap[uint256, String[432]]


@external
@payable
def __init__():
    self.name = "PudgyPenguins"
    self.symbol = "PPG"
    _BASE_URI = "ipfs://bafybeibc5sgo2plmjkq2tzmhrn54bk3crhnc23zd2msg4ea7a4pxrkgfna/"
    self.is_minter[msg.sender] = True


@external
@view
def supportsInterface(interface_id: bytes4) -> bool:
    return interface_id in _SUPPORTED_INTERFACES


@external
def safeTransferFrom(owner: address, to: address, id: uint256, amount: uint256, data: Bytes[1_024]):
    assert owner == msg.sender or self.isApprovedForAll[owner][msg.sender], "ERC1155: caller is not token owner or approved"
    self._safe_transfer_from(owner, to, id, amount, data)


@external
def safeBatchTransferFrom(owner: address, to: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE],
                          data: Bytes[1_024]):
    assert owner == msg.sender or self.isApprovedForAll[owner][msg.sender], "ERC1155: caller is not token owner or approved"
    self._safe_batch_transfer_from(owner, to, ids, amounts, data)


@external
@view
def balanceOf(owner: address, id: uint256) -> uint256:
    return self._balance_of(owner, id)


@external
@view
def balanceOfBatch(owners: DynArray[address, _BATCH_SIZE], ids: DynArray[uint256, _BATCH_SIZE]) -> DynArray[uint256, _BATCH_SIZE]:
    assert len(owners) == len(ids), "ERC1155: owners and ids length mismatch"
    batch_balances: DynArray[uint256, _BATCH_SIZE] = []
    idx: uint256 = empty(uint256)
    for owner in owners:
        batch_balances.append(self._balance_of(owner, ids[idx]))
        idx = unsafe_add(idx, 1)
    return batch_balances


@external
def setApprovalForAll(operator: address, approved: bool):
    self._set_approval_for_all(msg.sender, operator, approved)


@external
@view
def uri(id: uint256) -> String[512]:
    return self._uri(id)


@external
def set_uri(id: uint256, token_uri: String[432]):
    assert self.is_minter[msg.sender], "AccessControl: access is denied"
    self._set_uri(id, token_uri)


@external
def burn(owner: address, id: uint256, amount: uint256):
    assert owner == msg.sender or self.isApprovedForAll[owner][msg.sender], "ERC1155: caller is not token owner or approved"
    self._burn(owner, id, amount)


@external
def burn_batch(owner: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE]):
    assert owner == msg.sender or self.isApprovedForAll[owner][msg.sender], "ERC1155: caller is not token owner or approved"
    self._burn_batch(owner, ids, amounts)


@external
def safe_mint(owner: address, id: uint256, amount: uint256, data: Bytes[1_024]):
    assert self.is_minter[msg.sender], "AccessControl: access is denied"
    self._safe_mint(owner, id, amount, data)


@external
def safe_mint_batch(owner: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE], data: Bytes[1_024]):
    assert self.is_minter[msg.sender], "AccessControl: access is denied"
    self._safe_mint_batch(owner, ids, amounts, data)


@internal
def _set_approval_for_all(owner: address, operator: address, approved: bool):
    assert owner != operator, "ERC1155: setting approval status for self"
    self.isApprovedForAll[owner][operator] = approved
    log ApprovalForAll(owner, operator, approved)


@internal
def _safe_transfer_from(owner: address, to: address, id: uint256, amount: uint256, data: Bytes[1_024]):
    assert to != empty(address), "ERC1155: transfer to the zero address"

    self._before_token_transfer(owner, to, self._as_singleton_array(id), self._as_singleton_array(amount), data)

    owner_balance: uint256 = self._balances[id][owner]
    assert owner_balance >= amount, "ERC1155: insufficient balance for transfer"
    self._balances[id][owner] = unsafe_sub(owner_balance, amount)
    self._balances[id][to] = unsafe_add(self._balances[id][to], amount)
    log TransferSingle(msg.sender, owner, to, id, amount)

    self._after_token_transfer(owner, to, self._as_singleton_array(id), self._as_singleton_array(amount), data)

    assert self._check_on_erc1155_received(owner, to, id, amount, data), "ERC1155: transfer to non-ERC1155Receiver implementer"


@internal
def _safe_batch_transfer_from(owner: address, to: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE],
                              data: Bytes[1_024]):
    assert len(ids) == len(amounts), "ERC1155: ids and amounts length mismatch"
    assert to != empty(address), "ERC1155: transfer to the zero address"

    self._before_token_transfer(owner, to, ids, amounts, data)

    idx: uint256 = empty(uint256)
    for id in ids:
        amount: uint256 = amounts[idx]
        owner_balance: uint256 = self._balances[id][owner]
        assert owner_balance >= amount, "ERC1155: insufficient balance for transfer"
        self._balances[id][owner] = unsafe_sub(owner_balance, amount)
        self._balances[id][to] = unsafe_add(self._balances[id][to], amount)
        idx = unsafe_add(idx, 1)

    log TransferBatch(msg.sender, owner, to, ids, amounts)

    self._after_token_transfer(owner, to, ids, amounts, data)

    assert self._check_on_erc1155_batch_received(owner, to, ids, amounts, data), "ERC1155: transfer to non-ERC1155Receiver implementer"


@internal
@view
def _balance_of(owner: address, id: uint256) -> uint256:
    assert owner != empty(address), "ERC1155: address zero is not a valid owner"
    return self._balances[id][owner]


@internal
def _safe_mint(owner: address, id: uint256, amount: uint256, data: Bytes[1_024]):
    assert owner != empty(address), "ERC1155: mint to the zero address"

    self._before_token_transfer(empty(address), owner, self._as_singleton_array(id), self._as_singleton_array(amount), data)
    self._balances[id][owner] = unsafe_add(self._balances[id][owner], amount)
    log TransferSingle(msg.sender, empty(address), owner, id, amount)

    self._after_token_transfer(empty(address), owner, self._as_singleton_array(id), self._as_singleton_array(amount), data)

    assert self._check_on_erc1155_received(empty(address), owner, id, amount, data), "ERC1155: mint to non-ERC1155Receiver implementer"


@internal
def _safe_mint_batch(owner: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE], data: Bytes[1_024]):

    assert len(ids) == len(amounts), "ERC1155: ids and amounts length mismatch"
    assert owner != empty(address), "ERC1155: mint to the zero address"

    self._before_token_transfer(empty(address), owner, ids, amounts, data)

    idx: uint256 = empty(uint256)
    for id in ids:
        self._balances[id][owner] = unsafe_add(self._balances[id][owner], amounts[idx])
        idx = unsafe_add(idx, 1)

    log TransferBatch(msg.sender, empty(address), owner, ids, amounts)

    self._after_token_transfer(empty(address), owner, ids, amounts, data)

    assert self._check_on_erc1155_batch_received(empty(address), owner, ids, amounts, data), "ERC1155: transfer to non-ERC1155Receiver implementer"


@internal
@view
def _uri(id: uint256) -> String[512]:
    token_uri: String[432] = self._token_uris[id]

    base_uri_length: uint256 = len(_BASE_URI)
    if (base_uri_length == empty(uint256)):
        return token_uri

    if (len(token_uri) != empty(uint256)):
        return concat(_BASE_URI, token_uri)

    if (base_uri_length != empty(uint256)):
        return concat(_BASE_URI, uint2str(id))
    else:
        return ""


@internal
def _set_uri(id: uint256, token_uri: String[432]):
    self._token_uris[id] = token_uri
    log URI(self._uri(id), id)


@internal
def _burn(owner: address, id: uint256, amount: uint256):
    assert owner != empty(address), "ERC1155: burn from the zero address"

    self._before_token_transfer(owner, empty(address), self._as_singleton_array(id), self._as_singleton_array(amount), b"")
    owner_balance: uint256 = self._balances[id][owner]
    assert owner_balance >= amount, "ERC1155: burn amount exceeds balance"
    self._balances[id][owner] = unsafe_sub(owner_balance, amount)
    log TransferSingle(msg.sender, owner, empty(address), id, amount)

    self._after_token_transfer(owner, empty(address), self._as_singleton_array(id), self._as_singleton_array(amount), b"")


@internal
def _burn_batch(owner: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE]):
    assert len(ids) == len(amounts), "ERC1155: ids and amounts length mismatch"
    assert owner != empty(address), "ERC1155: burn from the zero address"

    self._before_token_transfer(owner, empty(address), ids, amounts, b"")

    idx: uint256 = empty(uint256)
    for id in ids:
        amount: uint256 = amounts[idx]
        owner_balance: uint256 = self._balances[id][owner]
        assert owner_balance >= amount, "ERC1155: burn amount exceeds balance"
        self._balances[id][owner] = unsafe_sub(owner_balance, amount)
        idx = unsafe_add(idx, 1)

    log TransferBatch(msg.sender, owner, empty(address), ids, amounts)

    self._after_token_transfer(owner, empty(address), ids, amounts, b"")


@internal
def _check_on_erc1155_received(owner: address, to: address, id: uint256, amount: uint256, data: Bytes[1_024]) -> bool:
    if (to.is_contract):
        return_value: bytes4 = IERC1155Receiver(to).onERC1155Received(msg.sender, owner, id, amount, data)
        assert return_value == method_id("onERC1155Received(address,address,uint256,uint256,bytes)", output_type=bytes4)
        return True
    else:
        return True


@internal
def _check_on_erc1155_batch_received(owner: address, to: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE], data: Bytes[1_024]) -> bool:

    if (to.is_contract):
        return_value: bytes4 = IERC1155Receiver(to).onERC1155BatchReceived(msg.sender, owner, ids, amounts, data)
        assert return_value == method_id("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)", output_type=bytes4)
        return True
    else:
        return True


@internal
def _before_token_transfer(owner: address, to: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE], data: Bytes[1_024]):

    if (owner == empty(address)):
        idx: uint256 = empty(uint256)
        for id in ids:
            self.total_supply[id] += amounts[idx]
            idx = unsafe_add(idx, 1)

    if (to == empty(address)):
        idx: uint256 = empty(uint256)
        for id in ids:
            amount: uint256 = amounts[idx]
            supply: uint256 = self.total_supply[id]
            assert supply >= amount, "ERC1155: burn amount exceeds total_supply"
            self.total_supply[id] = unsafe_sub(supply, amount)
            idx = unsafe_add(idx, 1)


@internal
def _after_token_transfer(owner: address, to: address, ids: DynArray[uint256, _BATCH_SIZE], amounts: DynArray[uint256, _BATCH_SIZE], data: Bytes[1_024]):
    pass


@internal
@pure
def _as_singleton_array(element: uint256) -> DynArray[uint256, 1]:
    return [element]