//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Counters.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "clones-with-immutable-args/Clone.sol";

contract Collection is ERC721URIStorage, Clone {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    address athleteAddress = _getArgAddress(0);
    uint256 price = _getArgUint256(40);
    uint256 maxSize = _getArgUint256(72);
    address addressToPay = _getArgAddress(20);
    bytes32 metadataIpfsHash = bytes32(_getArgUint256(104));

    function append(string memory a, string memory b)
        internal
        pure
        returns (string memory)
    {
        return string(abi.encodePacked(a, b));
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

    constructor() public ERC721("Collection", "CXN") {}

    function getCurrentTokenId() external view returns (uint256) {
        return _tokenId._value;
    }

    function mintNFT() external payable returns (uint256) {
        require(msg.value == price, "Insufficient funds");
        require(_tokenId._value < maxSize, "Collection is sold out");
        _tokenId.increment();

        uint256 newItemId = _tokenId.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(
            newItemId,
            append(
                "https://gateway.pinata.cloud/ipfs",
                bytes32ToStr(metadataIpfsHash)
            )
        );
        return newItemId;
    }
}
