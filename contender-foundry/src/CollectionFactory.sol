//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "clones-with-immutable-args/ClonesWithImmutableArgs.sol";
import "./Collection.sol";

contract CollectionFactory {
    using ClonesWithImmutableArgs for address;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Collection public implementation;

    event NewCollection(
        string id,
        string name,
        string description,
        address indexed athleteAddress,
        uint256 price,
        uint256 maxSize,
        address indexed addressToPay,
        string imageIpfsHash,
        string metadataIpfsHash,
        address contractAddress
    );

    constructor(Collection implementation_) {
        implementation = implementation_;
    }

    function bytes32ToStr(bytes32 _bytes32)
        public
        pure
        returns (string memory)
    {
        bytes memory bytesArray = new bytes(32);
        for (uint256 i; i < 32; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function createCollection(
        string memory id,
        string memory name,
        string memory description,
        address athleteAddress,
        uint256 price,
        uint256 maxSize,
        address addressToPay,
        string memory imageIpfsHash,
        bytes32 metadataIpfsHash
    ) external returns (Collection) {
        bytes memory data = abi.encodePacked(
            athleteAddress,
            addressToPay,
            price,
            maxSize,
            metadataIpfsHash
        );
        Collection clone = Collection(address(implementation).clone(data));
        emit NewCollection(
            id,
            name,
            description,
            athleteAddress,
            price,
            maxSize,
            addressToPay,
            imageIpfsHash,
            bytes32ToStr(metadataIpfsHash),
            address(clone)
        );
        return clone;
    }
}
