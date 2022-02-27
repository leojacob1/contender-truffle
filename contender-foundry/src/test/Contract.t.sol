// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../CollectionFactory.sol";
import "../Collection.sol";

interface CheatCodes {
    function prank(address) external;
}

contract CollectionFactoryTest is DSTest {
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);
    CollectionFactory collectionFactory;

    function stringToBytes32(string memory source)
        public
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function setUp() public {
        collectionFactory = new CollectionFactory(new Collection());
    }

    function testExample() public {
        Collection clone = collectionFactory.createCollection(
            "Cl-FROSH-342",
            "Frosh SZN",
            "Mo hits tanks",
            0x9bEF1f52763852A339471f298c6780e158E43A68,
            50000000000000000,
            25,
            0x750EF1D7a0b4Ab1c97B7A623D7917CcEb5ea779C,
            "QmcTFvGz8MbtcWVY4gLRTA7HNNBf3jmZ8NcjpNdRYSAiRd",
            "QmPxQPXXLrHZWUQQ3Z5DbyjntXtwFBdZPZRZxumZtmXBPc"
        );
        emit log_address(address(clone));
        assertEq(clone.getCurrentTokenId(), 0);
        // cheats.prank(0x9bEF1f52763852A339471f298c6780e158E43A68);
        uint256 newTokenId = clone.mintNFT{value: 50000000000000000}();
        assertEq(newTokenId, 1);
        emit log_address(clone.ownerOf(newTokenId));

        // emit log_address(clone.getAthleteAddress());
        // emit log_address(clone.getAddressToPay());
        // emit log_uint(clone.getPrice());
        // emit log_uint(clone.getMaxSize());
        // emit log(clone.getMetadataIpfsHash());
    }
}
