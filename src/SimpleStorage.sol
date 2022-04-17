// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SimpleStorage {
  bytes32 public DOMAIN_SEPARATOR_HASH;
  bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
  bytes32 constant SET_TYPEHASH = keccak256("set(address sender,uint x)");
  uint storedData;

  struct EIP712Domain {
    string  name;
    string  version;
    uint256 chainId;
    address verifyingContract;
  }

  constructor() {
    DOMAIN_SEPARATOR_HASH = hashEIP712Domain(EIP712Domain({
      name: "ERC712 Example",
      version: '1',
      chainId: 1,
      verifyingContract: 0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC
    }));
  }


  function hashEIP712Domain(EIP712Domain memory eip712Domain) internal pure returns (bytes32) {
    return keccak256(abi.encode(
      EIP712DOMAIN_TYPEHASH,
      keccak256(bytes(eip712Domain.name)),
      keccak256(bytes(eip712Domain.version)),
      eip712Domain.chainId,
      eip712Domain.verifyingContract
    ));
  }

  function executeSetIfSignatureMatch(uint8 v,bytes32 r,bytes32 s,address sender,uint x) external {
    bytes32 hashStruct = keccak256(
      abi.encode(
        SET_TYPEHASH,
        sender,
        x
      )
    );
    bytes32 hashData = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR_HASH, hashStruct));

    address signerAddress = ecrecover(hashData, v, r, s);

    require(signerAddress == sender, "MyFunction: invalid signature");
    require(signerAddress != address(0), "ECDSA: invalid signature");
    set(x);
  }


  function set(uint x) internal {
    storedData = x;
  }

  function get() public view returns (uint) {
    return storedData;
  }
}
