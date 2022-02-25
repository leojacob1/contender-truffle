//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Card is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(string => Counters.Counter) private collectionIdToCounter;

    event NewCollection(
        string id,
        string name,
        string description,
        address indexed athleteAddress,
        uint256 price,
        uint256 maxSize,
        address indexed addressToPay,
        string imageIpfsHash,
        string metadataIpfsHash
    );

    constructor() public ERC721("Card", "CRD") {}

    function createCollection(
        string memory id,
        string memory name,
        string memory description,
        address athleteAddress,
        uint256 price,
        uint256 maxSize,
        address addressToPay,
        string memory imageIpfsHash,
        string memory metadataIpfsHash
    ) external {
        Counters.Counter memory initTokenId;
        collectionIdToCounter[id] = initTokenId;
        emit NewCollection(
            id,
            name,
            description,
            athleteAddress,
            price,
            maxSize,
            addressToPay,
            imageIpfsHash,
            metadataIpfsHash
        );
    }

    function getEventCounters(string[] memory eventIds)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory requestedCollectionCounters;
        for (uint256 i = 0; i < eventIds.length; i++) {
            requestedCollectionCounters[i] = collectionIdToCounter[eventIds[i]]
                ._value;
        }
        return requestedCollectionCounters;
    }

    function mintNFT(
        string memory collectionId,
        uint256 price,
        uint256 maxSize,
        address payable addressToPay,
        string memory tokenURI
    ) public payable returns (uint256) {
        require(msg.value >= price, "Insufficient funds");
        require(
            addressToPay == address(addressToPay),
            "Invalid address to pay"
        );
        require(
            collectionIdToCounter[collectionId]._value >= maxSize,
            "Collection is sold out"
        );
        collectionIdToCounter[collectionId].increment();

        uint256 newItemId = collectionIdToCounter[collectionId].current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        addressToPay.transfer(price);
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
        return newItemId;
    }
}
