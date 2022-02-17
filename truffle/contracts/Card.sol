//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Card is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Collection {
        string id;
        string collectionName;
        address athleteAddress;
        uint maxSize;
        uint numMints;
        address addressToPay;
    }

    Collection[] public collections;

    event NewCollection(
        string collectionId,
        string collectionName, 
        address indexed athleteAddress, 
        uint maxSize, 
        address indexed addressToPay
    );

    constructor() public ERC721("Card", "CRD") {}

    function createCollection(
        string memory collectionId,
        string memory collectionName, 
        address athleteAddress, 
        uint maxSize, 
        address addressToPay) external {
        collections.push(Collection(collectionId, collectionName, athleteAddress, maxSize, 0, addressToPay));
        emit NewCollection(collectionId, collectionName, athleteAddress, maxSize, addressToPay);
    }


    function mintNFT(address recipient, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}