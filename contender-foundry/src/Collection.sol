//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "clones-with-immutable-args/Clone.sol";

contract Collection is Clone, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    address athleteAddress;
    uint256 price;
    uint256 maxSize;
    address addressToPay;
    bytes metadataIpfsHash;

    function append(string memory a, string memory b)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(a, b));
    }

    function concat(bytes32 b1, bytes32 b2) public pure returns (bytes memory) {
        bytes memory result = new bytes(46);
        assembly {
            mstore(add(result, 32), b1)
            mstore(add(result, 64), b2)
        }
        return result;
    }

    constructor() public ERC721("Collection", "CXN") {}

    function getCurrentTokenId() external view returns (uint256) {
        return _tokenId._value;
    }

    function getAthleteAddress() external view returns (address) {
        return athleteAddress;
    }

    function getAddressToPay() external view returns (address) {
        return addressToPay;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function getMaxSize() external view returns (uint256) {
        return maxSize;
    }

    function getMetadataIpfsHash() external view returns (string memory) {
        return string(metadataIpfsHash);
    }

    function mintNFT() external payable returns (uint256) {
        athleteAddress = _getArgAddress(0);
        price = _getArgUint256(40);
        maxSize = _getArgUint256(72);
        addressToPay = _getArgAddress(20);

        uint256[] memory uintArr = _getArgUint256Array(104, 3);
        uint256 one = uintArr[0];
        uint256 two = uintArr[1];
        bytes32 metadataIpfsHashOne = bytes32(one);
        bytes32 metadataIpfsHashTwo = bytes32(bytes14(bytes32(two)));
        metadataIpfsHash = concat(metadataIpfsHashOne, metadataIpfsHashTwo);

        require(msg.value == price, "Insufficient funds");
        require(_tokenId._value < maxSize, "Collection is sold out");
        _tokenId.increment();
        uint256 newItemId = _tokenId.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(
            newItemId,
            append("gateway.pinata.cloud/ipfs/", string(metadataIpfsHash))
        );
        return newItemId;
    }
}
